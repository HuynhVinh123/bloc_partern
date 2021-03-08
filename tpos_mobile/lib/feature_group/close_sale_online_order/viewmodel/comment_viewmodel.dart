import 'dart:async';

import 'package:facebook_api_client/facebook_api_client.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_data.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/order_data.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/auto_hide_facebook_comment_from_ui_middleware.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/auto_hide_facebook_comment_middleware.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/comment_fetching_service.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/comment_middlewares.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/comment_midleware.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/order_middlewares.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/order_midleware.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/services/print_order_middleware.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';

import 'comments_viewmodel.dart';

/// Alway active by register it into get_it library
class CommentViewModel {
  CommentViewModel({
    CommentFetchingService commentFetchingService,
    CommentSetting commentSetting,
  }) {
    print('CommentViewModel contructor');
    _commentSetting = commentSetting ?? CommentSetting();
    _commentFetchingServices =
        commentFetchingService ?? FacebookCommentFetchingService();
    _commentMiddlewares = CommentMiddlewares();

    _commentFetchingServices.commentStream
        .listen((FacebookComment event) async {
      await _addCommentFromFacebookComment(event);
    });

    _init();
  }

  final Logger _logger = Logger();
  CommentsViewModel _commentsViewModel;

  /// Store setting for comment fetching and create order
  CommentSetting _commentSetting;

  /// Fetching service
  CommentFetchingService _commentFetchingServices;

  /// Handle comment
  CommentMiddlewares _commentMiddlewares;

  /// Handle order
  OrderMiddlewares _orderMiddlewares;

  final List<CommentData> _comments = <CommentData>[];
  final List<SaleOnlineOrder> _orders = <SaleOnlineOrder>[];
  Product _product;
  final int _productQuantity = 0;

  /*-------------------VIEW ----------------------*/
  static const PAGE_SIZE = 500;
  static const FIRST_PAGE_SIZE = 200;

  List<List<CommentData>> _pagingViewComments;

  /// Report
  int get commentCount => _comments.length;
  int get shareCount => 0;
  int get orderCount => _orders.length;
  bool get isLive => _commentFetchingServices.isLive;

  FacebookPost get facebookPost => _commentSetting.facebookPost;
  CommentSetting get commentSetting => _commentSetting;

  /// call after [CommentViewModel] is contructor;
  void _init() {}

  /// call after [UI] is loaded;
  void load() {
    assert(_commentSetting != null);
    assert(_commentSetting.facebookPost != null);
    assert(_commentSetting.crmTeam != null);
  }

  /// Setup comment middleware
  void setupCommentMiddleware() {
    // setup processor service

    // Map [Parnter] tương ứng vào [commentData]
    // Map [Order] tương ứng vào [commentData]
    _commentMiddlewares.add(
      CommentWrapperMiddleware(
        onReceiver: (CommentData comment) {
          print('Map an exits partner to [commentData]');
          final Partner existsPartner = _commentsViewModel
              .getPartnerByFacebookId(comment.commentAuthorId);
          if (existsPartner != null) {
            comment.partner = existsPartner;
          }
          print('Map an exits order to [commentData]');

          final SaleOnlineOrder existsOrder = _orders.firstWhere(
              (element) => element.facebookAsuid == comment.commentAuthorId,
              orElse: () => null);

          if (existsPartner != null) {
            comment.order = existsOrder;
          }

          return comment;
        },
      ),
    );

    // Tự động ẩn comment trên facebook theo cài đặt. Chỉ các comment có [canHide] và đang ở trạng thái isHidden =false mới được thực thi lệnh
    // Việc tự động ẩn sẽ được đưa vào quene và thực thi lần lượt theo thứ tự và không đồng bộ
    _commentMiddlewares.add(
      AutoHideCommentMiddleWare(
          accessToken: _commentSetting.crmTeam.userOrPageToken,
          hideCommentSetting: _commentSetting.hideCommentOnFacebookSetting),
    );

    // Tự động ẩn các comment được cấu hình ko được phép hiển thị lên giao diện
    _commentMiddlewares.add(AutoHideCommentFromUiMiddlware());

    // Tự động tạo đơn hàng theo cấu hình
    _commentMiddlewares.add(
      CommentWrapperMiddleware(
        onReceiver: (CommentData comment) {
          print('middleware auto  create order');
          return comment;
        },
      ),
    );

    // Sắp xếp comment đi vào view phân trang
    _commentMiddlewares.add(
      CommentWrapperMiddleware(
        onReceiver: (CommentData comment) {
          print('comment middeware => Sắp xếp phân trang');
          final lastItem = _pagingViewComments.last;
          if (lastItem.length <= PAGE_SIZE) {
            lastItem.add(comment);
          } else {
            final List<CommentData> newList = <CommentData>[
              comment,
            ];
            _pagingViewComments.insert(0, newList);
          }
          return comment;
        },
      ),
    );
  }

  /// Setup order middleware
  void setupOrderMiddleware() {
    // Lưu các thông số cần thiết để khởi tạo đơn hàng
    // Chỗ này còn gắn ghi chú vào đơn hàng theo cài đặt
    // Nếu đơn hàng không kèm comment thì bước này sẽ được bỏ qua
    _orderMiddlewares.add(
      OrderWrapperMiddleware(
        onReceiver: (orderData) {
          print('order middleware | Print order ');
          // Nếu không gắn với comment là các order được tạo mới
          if (orderData.lastComment != null) {
            assert(orderData.order.id == null || orderData.order.id.isEmpty);
            assert(_commentSetting.facebookPost != null &&
                _commentSetting.facebookPost.id != null);
            assert(orderData.lastComment != null &&
                orderData.lastComment.comment != null);

            orderData.order.crmTeamId = _commentSetting.crmTeam.id;
            orderData.order.liveCompaignId = _commentSetting.liveCampaign?.id;
            orderData.order.liveCampaignName =
                _commentSetting.liveCampaign?.name;
            orderData.order.facebookPostId = _commentSetting.facebookPost.id;
            orderData.order.facebookAsuid =
                orderData.lastComment.comment.from.id;
            orderData.order.facebookUserName =
                orderData.lastComment.comment?.from?.name;
            orderData.order.facebookCommentId =
                orderData.lastComment.comment.id;
            orderData.order.name = orderData.order.facebookUserName;

            if (_commentSetting.printOrderSetting.addCommentToOrderNote) {
              orderData.order.note = orderData.lastComment.comment.message;
            }

            /// Chỗ này nếu comment có số điện thoại thì lấy nó và truyền vào
            final String phoneFromComment =
                getPhoneNumber(orderData.lastComment.message);
            if (phoneFromComment != null && phoneFromComment != "") {
              orderData.order.telephone = phoneFromComment;
            }

            // Chỗ này kiểm tra nếu có chọn sản phẩm thì bổ sung vào

            //Add product
            if (_product != null) {
              orderData.order.totalAmount = _product.price.toDouble();
              orderData.order.details = <SaleOnlineOrderDetail>[];
              orderData.order.details.add(
                SaleOnlineOrderDetail(
                  productId: _product.id,
                  price: _product.price,
                  productName: _product.name,
                  uomId: _product.uOMId,
                  uomName: _product.uOMName,
                  quantity: _productQuantity.toDouble(),
                ),
              );

              orderData.order.totalQuantity =
                  _productQuantity != null ? _productQuantity.toDouble() : 0;
              orderData.order.totalAmount =
                  (_productQuantity ?? 0) * _product.price;
            }

            orderData.order.comments = <TPosFacebookComment>[];
          } else {
            // Và ngược lại. đây là order được gửi về từ một nguồn khác.
          }

          return orderData;
        },
      ),
    );

    // Lưu đơn hàng về server
    // Nếu đơn hàng đã có id thì bước này sẽ được bỏ qua
    _orderMiddlewares.add(
      OrderWrapperMiddleware(
        onReceiver: (orderData) async {
          print('order middleware | Print order ');
          await _saveOrder(orderData);
          return orderData;
        },
      ),
    );
    // In đơn hàng mỗi khi có đơn hàng mới được thêm vào
    // Việc in đơn hàng sẽ được chuyển qua một Quene và thực hiện lần lượt nhằm đẩm bảo tính ổn định
    // Việc thực hiện in là bất đồng bộ. [Order] sẽ được trả về cho ui cập nhật lên giao diện và ko phụ thuộc vào việc in đã xong hay chưa
    // Order nếu không có kèm một comment sẽ không được in
    _orderMiddlewares.add(
      PrintOrderMiddleware(
        printOrderSetting: _commentSetting.printOrderSetting,
      ),
    );
  }

  /// Nhận một comment từ [FetchingService]  biến đổi nó thành một [CommmentData] và bổ sung vào danh sách [commemnts]
  /// Các [commentData] được đẩy theo thứ tự vào [middleware]
  Future<void> _addCommentFromFacebookComment(FacebookComment comment) async {
    print("add new comment");
    // add comment for each middleware
    CommentData data = CommentData(comment: comment);

    // map to order
    final exitsOrder = _orders.firstWhere(
        (element) => element.partnerId == data.partner.id,
        orElse: () => null);

    if (exitsOrder != null) {
      data.order = exitsOrder;
    }

    for (final CommentMiddleware middleware in _commentMiddlewares) {
      data = await middleware.onReceiver(data);
      if (data == null) {
        break;
      }
    }

    if (data != null) {
      _comments.add(data);
    }
  }

  /// create an order. from manual or from automatic
  Future<void> _saveOrder(OrderData orderData) async {
    assert(orderData.order != null);
    assert(orderData.order.id == null || orderData.order.id.isEmpty);

    try {} catch (e, s) {
      _logger.e('_saveOrder', e, s);
    }
    return;
  }

  /// Add new order to list order
  Future<void> _addOrder(OrderData order) async {
    print('add new sale online order');
    assert(order != null);
    assert(order.order != null);

    OrderData saleOnlineOrder = order;
    for (final OrderMiddleware middleware in _orderMiddlewares) {
      saleOnlineOrder = await middleware.onReceiver(saleOnlineOrder);
    }

    if (saleOnlineOrder.order == null) {
      return;
    }
    _orders.add(saleOnlineOrder.order);
  }

  /// Handle refresh all infomation and list of comment
  // ignore: missing_return
  Future<void> handleRefresh() {}

  /// Xử lý yêu cầu tạo đơn hàng được gọi từ UI
  ///
  /// Hàm này đơn giản chỉ tạo mới [OrderData] có gắn với [Comment] hiện tại và một
  /// [SaleOnlineOrder] rỗng
  Future<void> handleCreateOrder({CommentData commentData}) async {
    _addOrder(
      OrderData(
        lastComment: commentData,
        order: SaleOnlineOrder(),
      ),
    );
  }

  /// Handle download the excel with all comment or only phone
  // ignore: missing_return
  Future<void> handleExportToExcel({bool onlyPhone = false}) {}

  /// Connect tpos printer and fetch facebook uid, map it to comment and save
  // ignore: missing_return
  Future<void> handleMapUidFromTposPrinter() {}

  void dispose() {}
}
