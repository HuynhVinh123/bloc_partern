import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:signalr_client/signalr_client.dart';
import 'package:timeago/timeago.dart' as time_ago;
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/services/remote_config_service.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';
import 'package:tpos_mobile/src/facebook_apis/src/enums/live_status.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';
import 'package:w3c_event_source/event_source.dart';

///
class NewFacebookPostCommentViewModel extends ViewModel {
  //Event
  static const String SCROLL_TO_FIRST = "SCROLL_TO_FIRST";
  static const String SCROLL_TO_BOTTOM = "SCROLL_TO_BOTTOM";
  static const String REFRESH_UI = "REFRESH_UI";
  static const String PAGGING_CHANGE_EVENT = "PAGGING_CHANGE";
  static const String REQUIRED_GO_BACK = "GoBackRequired";
  //Service
  IFacebookApiService _fbApi;
  ITposApiService _tposApi;
  PartnerApi _partnerApi;
  ISettingService _setting;
  DialogService _dialog;
  PrintService _printService;
  DataService _dataService;
  RemoteConfigService _remoteConfig;

  // Param
  String _facebookPostId;
  FacebookPost _facebookPost;
  CRMTeam _crmTeam;

  bool _isCancelAll = false;
  /*END PARAMETER*/
  // Phân  trang
  final int _firstPageSize = 200;
  final int _pageSize = 500;
  int _pageCount = 1;
  bool _isPagingVisible = true;
  int _currentPage = 1;
  int _notReadCommentCount = 0;

  /// Trạng thái video lúc khởi tạo
  LiveStatus _initLiveStatus;

  /// Trạng thái video trong khi live
  LiveStatus _currentLiveStatus;

  /// Thời gian tự động tải bình luận kết hợp vói realtime
  int _refreshManualCurrentDurationSecond = 30;
  int _refreshManualMaximumDurationSecond = 20;
  int _refreshManualMinimumDurationSecond = 2;
  int _commentCountPerMinute = 0;

  //Subcription event

  StreamSubscription _realtimeConmmentSubscription;
  StreamSubscription _commentsSubscription;
  StreamSubscription _searchSubcription;
  StreamSubscription _dataSubcription;
  NewFacebookPostCommentViewModel(
      {IFacebookApiService fbApi,
      ITposApiService tposApi,
      PartnerApi partnerApi,
      LogService logService,
      DialogService dialog,
      PrintService printSerice,
      DataService dataService,
      RemoteConfigService remoteConfig})
      : super(logService: logService) {
    _fbApi = fbApi ?? locator<IFacebookApiService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _setting = _setting ?? locator<ISettingService>();
    _dialog = dialog ?? locator<DialogService>();
    _printService = printSerice ?? locator<PrintService>();
    _dataService = dataService ?? locator<DataService>();
    _remoteConfig = remoteConfig ?? GetIt.I<RemoteConfigService>();

    /// Stream listening
    _realtimeConmmentSubscription = _realTimeCommentSubject
        .interval(const Duration(milliseconds: 20))
        .listen(
      (comment) {
        //Debug
        if (_realtimeComments.any((f) => f.facebookComment.id == comment.id)) {
          logger.debug("LỖI ĐÃ TỒN TẠI");
          return;
        }
        // Chuyển thành Comment Item Model
        var model = CommentItemModel(
          facebookComment: comment,
        );
        if (comment.comments != null && comment.comments.isNotEmpty) {
          model.comments = <CommentItemModel>[];
          comment.comments?.forEach(
            (cm) {
              final childModel = CommentItemModel(
                facebookComment: cm,
              );

              model.comments.add(childModel);
            },
          );
        }
        _mapCommentToOrderAndPartner([model]);
        _realtimeComments?.add(model);
        _comments.insert(0, model);
        _calculatePaging();

        if (_currentPage != 1) {
          _notReadCommentCount += 1;
        }
        // Notify update ui
        notifyListeners();
        realtimeCommentNotifySubject.add(1);
      },
    );

    _commentsSubscription = _commentsSubject.listen((comment) {
      for (var cm in comment) {
        final model = new CommentItemModel(
          facebookComment: cm,
        );
        if (cm.comments != null && cm.comments.isNotEmpty) {
          model.comments = <CommentItemModel>[];
          cm.comments?.forEach(
            (cm) {
              final childModel = CommentItemModel(
                facebookComment: cm,
              );

              model.comments.add(childModel);
            },
          );
        }
        _comments.insert(0, model);
        // Notify update ui
        notifyListeners();
      }
    });

    _searchSubcription = _searchCommentSubject
        .debounceTime(const Duration(milliseconds: 300))
        .listen((keyword) {
      _onSearchComments(keyword);
    });

    // Listen data (Order and partner update)

    _dataSubcription = _dataService.dataSubject.stream
        .where((f) => (f.value is Partner || f.value is SaleOnlineOrder))
        .listen((data) {
      logger.debug("Phát hiện thay đổi ${data.value.runtimeType}");
      if (data.value is Partner) {
        _onPartnerAdded(
          data.value,
        );
        // update partner
      } else if (data.value is SaleOnlineOrder) {
        //update order
        _onOrderAdded(data.value);
      }
    });
  }

  /*PROPERTY */
  /// Tất cả comment
  List<CommentItemModel> _comments = <CommentItemModel>[];

  /// Comment livestream
  List<CommentItemModel> _realtimeComments = <CommentItemModel>[];

  /// Comment tìm kiếm
  List<CommentItemModel> _searchComments;

  /// Comment hiển thị khi phân trang
  List<CommentItemModel> _viewComments;

  /// Comment đã có trên máy chủ
  final List<String> _savedCommentIds = <String>[];

  /// Store all order of this post
  final List<SaleOnlineOrder> _orders = <SaleOnlineOrder>[];

  /// List of partner (Facebook has order)
  final List<PartnerItemModel> _partner = <PartnerItemModel>[];

  /// Store paging info of facebook fetch comment request
  FacebookListPaging _facebookListPaging;

  /// Selected prodcut for this post
  Product _product;

  /// Live campaign assign to this post
  LiveCampaign _liveCampaign;

  /// Tổng số lượng sản phẩm
  int _totalProductQuantity = 0;

  Timer _timer;
  Timer _autoSaveCommentTimer;

  int get pageCount => _pageCount;
  bool _isTimerStarted = false;
  bool _isAutoScrollToLastEnable = true;
  EventSource _eventSource;
  StreamSubscription _eventSourceSubscription;

  HubConnection _hubConnection;

  /// setting realtime method
  RealtimeMethod _realtimeMethod = RealtimeMethod.AUTO;

  /// current realtime method (control by realtime inteligent)
  RealtimeMethod _currentRealtimeMethod = RealtimeMethod.NOT_SET;

  bool _isRealtimeManualStarted = false;
  bool _isRealtimeEventSourceStarted = false;

  /// buffer comment on stream
  var _realTimeCommentBufferSubject = new BehaviorSubject<FacebookComment>();

  /// Stream realtime comment
  /// Comment add to stream and output
  var _realTimeCommentSubject = new BehaviorSubject<FacebookComment>();
  var _commentsSubject = new BehaviorSubject<List<FacebookComment>>();
  var realtimeCommentNotifySubject = new BehaviorSubject<int>();
  var _searchCommentSubject = new BehaviorSubject<String>();

  BehaviorSubject<FacebookComment> get realTimeCommentStream =>
      _realTimeCommentSubject;

  Sink<String> get searchCommentSink => _searchCommentSubject.sink;

  double _productQuantity = 1;

  int get totalProductQuantity => _totalProductQuantity;

/*END PROPERTY*/

/*PUBLIC PROPERTY*/

  CRMTeam get crmTeam => _crmTeam;
  FacebookPost get facebookPost => _facebookPost;
  List<CommentItemModel> get comments => _comments;
  List<CommentItemModel> get realtimeComments => _realtimeComments;
  List<CommentItemModel> get viewComments => _viewComments;
  List<CommentItemModel> get searchComments => _searchComments;
  List<SaleOnlineOrder> get orders => _orders;
  List<PartnerItemModel> get partners => _partner;

  int get commentCount => _comments?.length ?? 0;
  int get orderCount => _orders?.length ?? 0;
  int get partnerCount => _partner?.length ?? 0;

  int get partnerOnPostCount {
    var partner = _comments
        .where((f) => f.partnerInfo != null)
        .map((s) => s.partnerInfo.partnerId)
        .toList();

    return partner.toSet().length;
  }

  bool get pageVisible => _isPagingVisible || _currentPage != 1;
  bool get isReverseCommentList {
    if (_setting.saleOnlineCommentDefaultOrderByOnLive ==
        SaleOnlineCommentOrderBy.DATE_CREATE_DESC) {
      if (_initLiveStatus == LiveStatus.LIVE) {
        return true;
      } else {
        return false;
      }
    } else {
      if (_initLiveStatus == LiveStatus.LIVE) {
        return false;
      } else {
        return true;
      }
    }
  }

  LiveStatus get initLiveStatus => _initLiveStatus;
  LiveStatus get currentLiveStatus => _currentLiveStatus;
  int get currentPage => _currentPage;
  String get productName => _product?.name;
  double get productQuantity => _productQuantity;
  String get liveCampaignName => _liveCampaign?.name;
  LiveCampaign get liveCampaign => _liveCampaign;
  Product get product => _product;
  RealtimeMethod get currentRealtimeMethod => _currentRealtimeMethod;
  // Status auto scroll to last
  bool get isAutoScrollToLastEnable => _isAutoScrollToLastEnable;

  /// Đếm số comment chưa đọc
  int get notReadCommentCount => _notReadCommentCount;
  set isAutoScrollToLastEnable(bool value) {
    _isAutoScrollToLastEnable = value;
  }

  void setProduct(Product product) {
    _product = product;
    notifyListeners();
  }

  void setProductQuantity(double value) {
    _productQuantity = value;
  }

  void _setCurrentRealtimeStatus(RealtimeMethod method) {
    if (_currentRealtimeMethod != method) {
      _currentRealtimeMethod = method;
      logger.debug("Status changed: ${method.toString()}");
    }
  }

  set pageVisible(bool value) {
    if (_isPagingVisible != value) {
      _isPagingVisible = value;
      notifyListeners();
    }
  }

  set currentPage(int value) {
    _currentPage = value;
    // Hiển thị kết  quả
    if (_initLiveStatus == LiveStatus.VOD) {
      _notReadCommentCount = 0;
      int skip = (_currentPage - 1) * _pageSize;
      int take = _pageSize;
      _viewComments = _comments.skip(skip).take(take).toList();
    } else if (_initLiveStatus == LiveStatus.LIVE) {
      if (_currentPage == 1) {
        _notReadCommentCount = 0;
        _viewComments = null;
      } else {
        if (_realtimeComments.length > _pageSize) {
          _realtimeComments.clear();
          _realtimeComments = _comments.take(_pageSize).toList();
        }

        int skip = _realtimeComments.length + (_currentPage - 2) * _pageSize;
        int take = _pageSize;
        _viewComments = _comments.skip(skip).take(take).toList();
      }
    }

    onEventAdd(PAGGING_CHANGE_EVENT, null);
    notifyListeners();
  }

  Future setLiveCampaign(LiveCampaign value) async {
    // Api thay đổi
    onStateAdd(true, message: "Đang cập nhật...");
    try {
      // update info
      LiveCampaign live = _liveCampaign ?? new LiveCampaign();
      live.id = value?.id ?? _liveCampaign.id;
      live.facebookLiveId = this._facebookPost.id;
      live.facebookUserId = this._facebookPost.from?.id;
      live.facebookUserName = this._facebookPost.from?.name;
      live.facebookUserAvatar = this._facebookPost.picture;
      final facebookPost = new TposFacebookPost(
        createdTime: this._facebookPost.createdTime,
        facebookId: this._facebookPost.id,
        fullPicture: this._facebookPost.picture,
        picture: this._facebookPost.picture,
        source: this._facebookPost.source,
        story: this._facebookPost.story,
        from: new TposFacebookFrom(
            id: _facebookPost.from?.id,
            name: _facebookPost.from?.name,
            picture: _facebookPost.from?.pictureLink),
        message: this._facebookPost.message,
      );

      live.facebookPost = facebookPost;

      await _tposApi.updateLiveCampaignFacebook(
          campaign: live,
          tposFacebookPost: facebookPost,
          isCancel: value == null);
      _dialog.showNotify(
          title: "Thông báo:",
          message: value != null
              ? "Đã thay đổi chiến dịch ${value.name}"
              : "Đã bỏ chọn chiến dịch ${_liveCampaign?.name}");
      _liveCampaign = value;
      notifyListeners();
    } catch (e, s) {
      logger.error("Thay đổi chiến dịch", e, s);
      _dialog.showError(title: "Đã xảy ra lỗi", content: e.toString());
    }

    onStateAdd(false, message: "Đang cập nhật...");
  }

/*  METHOD*/
  void init({CRMTeam crmTeam, FacebookPost post, String facebookPostId}) {
    assert(crmTeam != null);
    assert(post != null || facebookPostId != null);
    this._crmTeam = crmTeam;
    this._facebookPost = post;
    this._facebookPostId = facebookPostId;

    isInit = true;
  }

  Future<void> _fetchFacebookComment() async {
    logger.debug("fetch 200 facebook comments");
    _facebookListPaging = null;
    var fetchResult = await _fbApi.fetchCommentWithPaging(
        accessToken: _crmTeam.userOrPageToken,
        postId: _facebookPost.id,
        limit: _setting.getFacebookCommentTake,
        isNewestOnTop: true);

    this._facebookListPaging = fetchResult.paging;
    if (fetchResult.data != null) {
      var commentItemModels =
          _mapFacebookCommentsToCommentItemModels(fetchResult.data);

      // map order and partner
      _mapCommentToOrderAndPartner(commentItemModels);
      if (_initLiveStatus == LiveStatus.LIVE) {
        var commentToMap = commentItemModels.reversed.toList();
        _realtimeComments.addAll(commentToMap);
      } else {
        _realtimeComments.addAll(commentItemModels);
      }
      _comments.addAll(commentItemModels);
      _viewComments = _comments;
    }

    logger.debug("find ${_comments?.length} comments");
    notifyListeners();
    onEventAdd(SCROLL_TO_FIRST, null);
  }

  ///Tải toàn bộ bình luận tiếp theo
  Future<void> _fetchAllFacebookComment() async {
    while (_facebookListPaging != null && _facebookListPaging.next != null) {
      if (_isCancelAll) break;
      try {
        var result = await _fbApi.fetchMoreCommentWithPaging(
            _facebookListPaging, _crmTeam.userOrPageToken);

        this._facebookListPaging = result.paging;
        if (result.data != null) {
          var newComments =
              _mapFacebookCommentsToCommentItemModels(result.data);
          _mapCommentToOrderAndPartner(newComments);
          this._comments.addAll(newComments);
          _calculatePaging();
        }

        logger.debug("find ${_comments?.length} comments");
        notifyListeners();
      } catch (e, s) {
        logger.error("fetch all comment", e, s);
      }
    }
  }

  FacebookComment _lastRecentComment;

  Future _fetchRecentComments() async {
    var top50comments = await _fbApi.fetchTopComment(
        top: 50,
        postId: _facebookPost.id,
        accessToken: _crmTeam.userOrPageToken,
        lastTime: _lastRecentComment?.createdTime);

    print("duratoin ${top50comments.length}");
    _addCommentsToStream(top50comments.reversed.toList());
    if ((top50comments?.length ?? 0) > 0)
      _lastRecentComment = top50comments?.first;
  }

  /// Fetch by top 50 comment after 2s
  Future _fetchCommentOnReatimeManual() async {
    if (_isRealtimeManualStarted) return;
    logger.debug("Start fetch comment on realtime MANUAL");
    _isRealtimeManualStarted = true;
    while (_currentRealtimeMethod == RealtimeMethod.EVENT_SOURCE_AND_DURATION ||
        _currentRealtimeMethod == RealtimeMethod.DURATION) {
      try {
        await _fetchRecentComments();
      } catch (e, s) {
        logger.error("fetch comment", e, s);
      }

      //calculate second refresh
      await Future.delayed(
        Duration(seconds: _refreshManualCurrentDurationSecond),
      );
    }
    _isRealtimeManualStarted = false;
    logger.debug("End fetch comment MANUAL");
  }

  Future _fetchCommentOnRealtimeEventsource() async {
//    logger.debug("start fetch comment eventsource");
//
//    Future.delayed(Duration(seconds: 2));
//    while (_eventSource.readyState == EventSource.CONNECTING) {
//      await Future.delayed(Duration(seconds: 1));
//    }
//
//    if (_eventSource.readyState == EventSource.OPEN) {
//      _setCurrentRealtimeStatus(RealtimeMethod.EVENT_SOURCE);
//      notifyListeners();
//    }
//
//    if (_eventSource.readyState == EventSource.CLOSED) {
//      _eventSourceSubscription.cancel();
//    }
    return;
  }

  Future<void> _connectHub() async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(
            "https://tmt25.tpos.vn/signalr/connect?transport=webSockets&clientProtocol=1.5&&connectionToken=Oksmd5YVe7Kx2F5uQCdkRZ6l51urM6eZ8nboWH3OzTijoy0EywAPrMlE3HxkomMGuVAgLCV2hi7bJ9JRM2LvXIFgKhYULe8RCGmvOezfwwayb1PvQsNUR%2FbPzsj8Ez3L&connectionData=%5B%7B%22name%22%3A%22common%22%7D%5D&tid=0")
        .build();

    _hubConnection.onclose((error) {
      logger.debug("hub closed");
    });
    _hubConnection.on("OnMessage", (message) {
      print(message);
    });

    if (_hubConnection.state != HubConnectionState.Connected) {
      await _hubConnection.start();
    }
  }

  Future<void> _fetchPostInfo() async {
    logger.debug("fetch facebook post info");
    var post = await _fbApi.getFacebookPostById(
        _facebookPostId ?? _facebookPost.id, _crmTeam.userOrPageToken);

    if (post != null) {
      _facebookPost.story = post.story;
    }
  }

  Future<void> _checkLiveStatus() async {
    logger.debug("check post status");
    if (_facebookPost.type != "video") {
      _currentLiveStatus = null;
      return;
    }
    try {
      LiveVideo liveVideo = await _fbApi.getLiveVideo(
          accessToken: _crmTeam.userOrPageToken,
          liveVideoId: _facebookPost.idForEventSource);

      _currentLiveStatus = LiveStatus.values.firstWhere(
          (f) => f.toString().split(".")[1] == liveVideo.liveStatus);

      if (!isInitData) {
        _initLiveStatus = _currentLiveStatus;
      }
      logger.debug("video live status is ${liveVideo.liveStatus}");
    } catch (e, s) {
      logger.error("check post status", e, s);
    }
  }

  /// Lấy danh sách toàn bộ khách hàng đã lưu
  Future<void> _fetchPartner() async {
    logger.debug("start fetch partner");
    var getResult = await _tposApi.getFacebookPartners(_crmTeam.id);
    _partner.clear();
    getResult.forEach(
      (key, value) {
        _partner.add(
          PartnerItemModel(
            facebookAsuid: key,
            facebookUid: value.facebookId,
            partnerId: value.id,
            partnerCode: value.code,
            phone: value.phone,
            address: value.street,
            partnerStatus: value.status,
            partnerStatusText: value.statusText,
            partnerStatusStyle: value.statusStyle,
          ),
        );
      },
    );
    logger.debug("find ${_partner.length} partner");
  }

  /// Lấy toàn bộ đơn hàng của bài đăng
  Future<void> _fetchOrder() async {
    logger.debug("start fetch orders");
    var getResult = await _tposApi.getOrdersByFacebookPostId(_facebookPost.id);
    if (getResult != null) {
      await Future.forEach(
        getResult,
        (f) {
          _orders.add(f);
        },
      );
    } else {
      _orders.clear();
    }

    logger.debug("find ${_orders.length} orders");
  }

  /// Thêm bình luận facebook vào stream
  /// FacebookComment -> CommentItemModel
  void _addCommentToStream(FacebookComment comment,
      {bool checkAny = true, String source = "N/A"}) {
    // Check any
    if (checkAny) {
      if (_comments.any((s) => s._facebookComment.id == comment.id)) {
        logger.debug("comment ${comment.id} đã tồn tại");
        return;
      }
    }
    // Hide comment short
    if (_setting.isSaleOnlineHideShortComment) {
      if (comment.message.length < 3) {
        logger.debug("hide comment ${comment.message}");
        return;
      }
    }

    if (!_realTimeCommentSubject.isClosed) {
      _realTimeCommentSubject.sink.add(comment);
      logger.debug("add new from $source");
    }
  }

  /// Add many comment to stream
  void _addCommentsToStream(List<FacebookComment> comments) {
    comments.forEach((f) {
      _addCommentToStream(f, checkAny: true, source: "DURATION");
    });

    notifyListeners();
  }

  Future _startTimer([int initDurationSecond = 1]) async {
    _timer?.cancel();
    _timer = null;

    if (_currentRealtimeMethod == RealtimeMethod.NONE) return;
    _timer = new Timer.periodic(
      Duration(seconds: 20),
      (timer) async {
        if (_isCancelAll) {
          _timer?.cancel();
          return;
        }
        // check reatime
        await _checkReatimeStatus();
      },
    );
  }

  void _startAutoSaveCommentTimer() {
    _autoSaveCommentTimer?.cancel();
    _autoSaveCommentTimer = null;
    _autoSaveCommentTimer = new Timer.periodic(
      Duration(minutes: _setting.settingSaleOnlineAutoSaveCommentMinute),
      (timer) {
        if (_isCancelAll) {
          _autoSaveCommentTimer?.cancel();
          return;
        }
        // tự lưu comment
        this.saveComment(showError: false);
        if (_initLiveStatus == LiveStatus.VOD ||
            _currentLiveStatus == null ||
            _currentLiveStatus == LiveStatus.VOD) {
          _autoSaveCommentTimer?.cancel();
        }
      },
    );
  }

  /// Thêm comment vào list
  void _addComments(List<FacebookComment> comments, bool) {
    this._realtimeComments = _mapFacebookCommentsToCommentItemModels(comments);
  }

  void addFakeComment(FacebookComment comment) {
    _addCommentToStream(comment, checkAny: false);
  }

  Future<void> _getSelectedLiveCampaign() async {
    if (_facebookPost.liveCampaignId != null) {
      _liveCampaign = await _tposApi.getLiveCampaignByPostId(_facebookPost.id);
    } else {
      _liveCampaign = null;
    }
  }

  int checkRealtimeCount = 0;
  Future<void> _checkReatimeStatus() async {
    checkRealtimeCount += 1;
    if (checkRealtimeCount == 30) {
      //fetch post info
      await _checkLiveStatus();
      checkRealtimeCount = 0;
    }
    logger.debug(
        "checking realtime status. Current running method: ${_currentRealtimeMethod.toString()}");

    //Check live status

    if (_currentLiveStatus == null || _currentLiveStatus == LiveStatus.VOD) {
      //stop timer
      _timer?.cancel();
      _dialog.showNotify(message: "Livestream đã kết thúc");
      _setCurrentRealtimeStatus(RealtimeMethod.NONE);
      notifyListeners();
      return;
    }

    switch (_realtimeMethod) {
      case RealtimeMethod.AUTO:
        // try connect event source first

        _calculateAutoTime();
        if (_eventSource == null ||
            _eventSource?.readyState == EventSource.OPEN) {
          _setCurrentRealtimeStatus(RealtimeMethod.EVENT_SOURCE_AND_DURATION);
          //Auto with duraton

          if (_crmTeam.facebookTypeId == "User") {
            if (_remoteConfig.facebookOption.enableFetchDurationUser) {
              _fetchCommentOnReatimeManual();
            }
          } else {
            _fetchCommentOnReatimeManual();
          }
        }

        if (_eventSource?.readyState == EventSource.CLOSED) {
          if (_currentRealtimeMethod != RealtimeMethod.DURATION) {
            _setCurrentRealtimeStatus(RealtimeMethod.DURATION);
            _fetchCommentOnReatimeManual();
          }
        }
        break;
      case RealtimeMethod.MANUAL:
        if (_currentRealtimeMethod != RealtimeMethod.DURATION) {
          await _fetchCommentOnReatimeManual();
        }
        return;
        break;
      case RealtimeMethod.EVENT_SOURCE:
        if (_eventSource?.readyState == EventSource.CLOSED) {
          await _listenEventSourceEvent();
        }
        break;
      case RealtimeMethod.DURATION:
        break;
      case RealtimeMethod.NONE:
        return;
        break;
      case RealtimeMethod.NOT_SET:
        return;
        break;
      case RealtimeMethod.EVENT_SOURCE_AND_DURATION:
        break;
    }
  }

  Future<void> _mapCommentToOrderAndPartner(
      List<CommentItemModel> comments) async {
    if (comments == null || comments.isEmpty) return;
    for (var cm in comments) {
      var order = _orders.firstWhere(
          (f) => f.facebookAsuid == cm._facebookComment?.from?.id,
          orElse: () => null);
      var partner = _partner.firstWhere(
          (f) => f.facebookAsuid == cm._facebookComment?.from?.id,
          orElse: () => null);

      cm.saleOnlineOrder = order;
      cm.partnerInfo = partner;
    }

    //logger.debug("map ${comments.length} to partner");
  }

  /// this is call one when init
  Future<void> _listenEventSourceEvent() async {
    logger.debug("listen event source event");
    _eventSourceSubscription?.cancel();
    _eventSource?.close();
    _eventSource = null;
    String filter = "";
    switch (_setting.saleOnlineFetchCommentOnRealtimeRate) {
      case CommentRate.one_per_two_seconds:
        filter = "one_per_two_seconds";
        break;
      case CommentRate.ten_per_second:
        filter = "ten_per_second";
        break;
      case CommentRate.one_hundred_per_second:
        filter = "one_hundred_per_second";
        break;
      default:
        filter = "one_hundred_per_second";
    }

    Uri uri = Uri.parse(
        "https://streaming-graph.facebook.com/${_facebookPost.idForEventSource}/live_comments?live_filter=no_filter&comment_rate=$filter&fields=id,is_hidden,message,from{id,name,picture},created_time&access_token=${_crmTeam.userOrPageToken}");
    _eventSource = new EventSource(
      uri,
      initialReconnectDelay: Duration(seconds: 1),
      maxReconnectDelay: Duration(minutes: 1),
    );

    _eventSourceSubscription = _eventSource.events.listen(
      (MessageEvent message) {
        //get comment and add to stream
        try {
          var comment = FacebookComment.fromMap(jsonDecode(message.data));
          _addCommentToStream(comment, checkAny: true, source: "EVENTSOURCE");
        } catch (e, s) {
          logger.error("parse comment from eventsource", e, s);
        }
      },
    )..onError((s) {
        print(s);
      });

    logger.debug(" end listen event source event");
  }

/* COMMAND*/

  /// Khởi tạo dữ liệu
  /// - Lấy toàn bộ khách hàng facebook
  /// - Lấy toàn bộ đơn hàng
  /// - Lấy trước 50 bình luận -> Lấy toàn bộ bình luận
  /// - Lấy bình luận thời gian thực nếu đang live
  Future<void> initCommand() async {
    _comments?.clear();
    _realtimeComments?.clear();
    _viewComments = null;
    _orders?.clear();
    _partner?.clear();
    _currentPage = 1;
    onStateAdd(true, message: "Đang tải...");
    try {
      // Kiểm  tra trạng thái live
      await _checkLiveStatus();
      notifyListeners();
      onStateAdd(true, message: S.current.fetchCustomer);
      await Future.wait([
        _fetchPartner(),
        _fetchOrder(),
        _getSelectedLiveCampaign(),
        _getCommentIds(),
        _fetchTotalProductQuantity(),
      ]);

      onStateAdd(true, message: S.current.fetchComments);
      await _fetchFacebookComment();
      await _checkReatimeStatus();
      await Future.delayed(Duration(seconds: 3));
      _startTimer(1);
      // Tạm thời tắt live reatime với Page
      if (_crmTeam.facebookTypeId == "User") {
        await _listenEventSourceEvent();
      }
      // Tạm thời áp dụng thời gian tải comment cố định cho page.
      if (_crmTeam.facebookTypeId == "Page") {
        _setting.saleOnlineFetchDurationEnableOnLive = true;
        if (_setting.secondRefreshComment > 3) {
          _setting.secondRefreshComment = 3;
        }
      }

      onStateAdd(false, message: "false");
      // fetch all comment while reatetime is starting
      await _fetchAllFacebookComment();
      _calculatePaging();

      // Tự lưu comment theo cài đặt
      _startAutoSaveCommentTimer();
      notifyListeners();
      isInitData = true;
    } catch (e, s) {
      logger.error("init", e, s);
      _dialog
          .showError(
              title: "Lỗi khởi tạo dữ liệu",
              buttonTitle: "ĐỒNG Ý",
              isRetry: true,
              error: e)
          .then((result) {
        if (result.type == DialogResultType.RETRY) this.initCommand();
        if (result.type == DialogResultType.GOBACK)
          onEventAdd(REQUIRED_GO_BACK, null);
      });
      isInitData = false;
    }
    onStateAdd(false, message: "false");
  }

  Future<void> exportExcel(String postId, BuildContext context) async {
    try {
      onStateAdd(true);
      var result = await _tposApi.exportExcel(postId);
      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "File của bạn đã được lưu ở thư  mục: $result. Bạn có muốn mở file?",
            context: context,
            path: result);
      } else {
        _dialog.showError(
            title: "Lối", content: "Bạn chưa cấp quyền cho ứng dụng!");
      }
      onStateAdd(false, message: "false");
    } catch (e, s) {
      _dialog.showError(title: "Lỗi", content: e.toString());

      onStateAdd(false, message: "false");
    }
  }

  void showDialogOpenFileExcel(
      {String content,
      BuildContext context,
      String path,
      String postId,
      String ASUid}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Thông báo"),
          content: Text("$content"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Text(
                "Mở thư mục lưu",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                if (Platform.isAndroid) {
                  OpenFile.open('/sdcard/download');
                } else {
                  String dirloc =
                      (await getApplicationDocumentsDirectory()).path;
                  OpenFile.open('$dirloc');
                }
              },
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  child: Text(
                    "Đóng",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    "${path != null ? "Mở" : "Xác nhận"}",
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (path != null) {
                      OpenFile.open('$path');
                    } else {
                      fetchCommentFacebook(postId, ASUid, context);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> exportExcelByPhone(String postId, BuildContext context) async {
    try {
      onStateAdd(true);
      var result = await _tposApi.exportExcelByPhone(postId);
      if (result != null) {
        showDialogOpenFileExcel(
            content:
                "File của bạn đã được lưu ở thư  mục: $result. Bạn có muốn mở file?",
            context: context,
            path: result);
      } else {
        _dialog.showError(
            title: "Lối", content: "Bạn chưa cấp quyền cho ứng dụng!");
      }
      onStateAdd(false, message: "false");
    } catch (e, s) {
      _dialog.showError(title: "Lỗi", content: e.toString());
      onStateAdd(false, message: "false");
    }
  }

  Future<void> fetchCommentFacebook(
      String postId, String ASUid, BuildContext context) async {
    try {
      onStateAdd(true);
      String videoId = postId.split("_")[1];
      var result = await _tposApi.fetchCommentFacebookByBody(videoId, ASUid);
      if (result != null) {
        _dialog.showNotify(
            title: "Thông báo",
            message:
                "Đồng bộ thành công! \n Comments: ${result.commentCount} \n ID Update: ${result.updateCount} \n Id mới: ${result.newCount}");
      }
      onStateAdd(false, message: "false");
    } catch (e, s) {
      _dialog.showError(title: "Lỗi", content: e.toString());
      onStateAdd(false, message: "false");
    }
  }

  /// Tính số trang
  void _calculatePaging() {
    if (_initLiveStatus == LiveStatus.LIVE) {
      if (commentCount >= _realtimeComments.length)
        _pageCount = (((commentCount - _firstPageSize) / _pageSize).ceil());
    } else {
      _pageCount = (((commentCount) / _pageSize).ceil());
    }

    bool isFirstSetCurrentPage = false;
    if (isFirstSetCurrentPage == false && _currentPage == 1 && _pageCount > 1) {
      currentPage = 1;
      isFirstSetCurrentPage = true;
    }
  }

  void _calculateAutoTime() {
    if (_currentRealtimeMethod == RealtimeMethod.DURATION) {
      // Set thời gian tự tải cố định
      _refreshManualCurrentDurationSecond = _setting.secondRefreshComment;
    } else if (_setting.saleOnlineFetchDurationEnableOnLive) {
      // set thời gian tự tải cố định
      _refreshManualCurrentDurationSecond = _setting.secondRefreshComment;
    } else if (_currentRealtimeMethod ==
        RealtimeMethod.EVENT_SOURCE_AND_DURATION) {
      _commentCountPerMinute = _realtimeComments
          .where((f) => f.facebookComment.createdTime
              .isAfter(DateTime.now().add(Duration(seconds: -300))))
          .toList()
          .length;

      int offset = 4;
      if (_crmTeam.facebookTypeId == "User") {
        offset = 15;
        _refreshManualMinimumDurationSecond = 2;
        _refreshManualMaximumDurationSecond = 15;
      } else if (_crmTeam.facebookTypeId == "Page") {
        _refreshManualMinimumDurationSecond = 1;
        _refreshManualMaximumDurationSecond = 10;
      }

      if (_commentCountPerMinute > 0)
        _refreshManualCurrentDurationSecond =
            offset * 300 ~/ _commentCountPerMinute;
      print(
          "CM per 5minute: $_commentCountPerMinute. Tải lại sau $_refreshManualCurrentDurationSecond");
      if (_refreshManualCurrentDurationSecond <
          _refreshManualMinimumDurationSecond)
        _refreshManualCurrentDurationSecond =
            _refreshManualMinimumDurationSecond;
      else if (_refreshManualCurrentDurationSecond >
          _refreshManualMaximumDurationSecond)
        _refreshManualCurrentDurationSecond =
            _refreshManualMaximumDurationSecond;
    }
  }

  //TẠO ĐƠN HÀNG

  Queue<CommentItemModel> _createdOrderQuene = new Queue<CommentItemModel>();
  Queue<CommentItemModel> _printOrderQuene = new Queue<CommentItemModel>();
  bool _isCreateOrderQueneRunning = false;
  bool _isPrintOrderQueneRunning = false;
  Future createdOrder(CommentItemModel model) async {
    model.setState(isBusy: true, message: "Đang chờ..");
    _createdOrderQuene.addFirst(model);
    if (_isCreateOrderQueneRunning) return;
    _isCreateOrderQueneRunning = true;
    while (_createdOrderQuene.isNotEmpty) {
      await Future.delayed(Duration(milliseconds: 200));
      //Create order
      var comment = _createdOrderQuene.last;

      _createOrderAndPrint(comment).catchError((e, s) {
        logger.error("create order failt", e, s);
        _dialog.showError(error: e, title: "Tạo phiếu thất bại");
        comment.setState(isBusy: false);
      });

      // print
      _createdOrderQuene.remove(comment);
    }
    _isCreateOrderQueneRunning = false;
  }

  Future<void> _printOrder(CommentItemModel model) async {
    model.setState(isBusy: true, message: "Chờ in..");
    _printOrderQuene.addFirst(model);
    if (_isPrintOrderQueneRunning) {
      return;
    }
    _isPrintOrderQueneRunning = true;
    while (_printOrderQuene.isNotEmpty) {
      if (Platform.isIOS) {
        await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
      final comment = _printOrderQuene.last;
      final order = comment.saleOnlineOrder;
      if (order != null) {
        try {
          comment.setState(isBusy: true, message: "Đang in");
          int retryCount = 1;
          while (retryCount > 0) {
            try {
              print("LÀKDJFDKFJDKJFDKJFDFJF");
              await _printService.printSaleOnlineTag(
                  order: order,
                  partnerStatus: model.partnerStatusText,
                  productName: _product?.name,
                  comment: comment.comment,
                  isPrintNode: false);
              comment.isPrinted = true;
              comment.isPrintError = false;
              retryCount = 0;
            } catch (e, s) {
              await Future.delayed(const Duration(microseconds: 5000));
              retryCount -= 1;
              logger.error("print order", e, s);
              if (retryCount <= 0) {
                rethrow;
              }
            }
          }
        } catch (e, s) {
          comment.isPrintError = true;
          logger.error("print order ${comment.saleOnlineOrder.id}", e, s);
          await _dialog.showError(
              error: e, title: "In phiếu thất bại!", isRetry: false);
//          if (dialogResult != null &&
//              dialogResult.type == DialogResultType.RETRY) break retry;
        }
      }
      comment.setState(isBusy: false);
      _printOrderQuene.remove(comment);
    }

    _isPrintOrderQueneRunning = false;
  }

  Future<void> _createOrderAndPrint(CommentItemModel comment) async {
    comment.setState(isBusy: true, message: "Đang lưu...");
    final SaleOnlineOrder order = SaleOnlineOrder();

    order.crmTeamId = _crmTeam.id;
    order.liveCompaignId = _liveCampaign?.id;
    order.liveCampaignName = _liveCampaign?.name;
    order.facebookPostId = _facebookPost.id;
    order.facebookAsuid = comment.facebookComment?.from?.id;
    order.facebookUserName = comment.facebookComment?.from?.name;
    order.facebookCommentId = comment.facebookComment.id;
    order.name = order.facebookUserName;
    order.note = "";

    if (_setting.isSaleOnlinePrintComment) {
      order.note = comment.comment;
    }

    //checkPartner
    final checkResult = await _tposApi.checkFacebookId(
        comment.facebookComment?.from?.id, _facebookPost.id, _crmTeam?.id,
        timeoutSecond: 15);

    if (checkResult != null) {
      order.facebookUserId = checkResult.uid;
      if (checkResult.customers != null && checkResult.customers.isNotEmpty) {
        order.partnerId = checkResult.customers.first.id;
        order.partnerName = checkResult.customers.first.name;
        order.facebookUserId = checkResult.customers.first.facebookId;
      }
    }

    /// Add new phone
    final String phoneFromComment = getPhoneNumber(comment.comment);
    if (phoneFromComment != null && phoneFromComment != "") {
      order.telephone = phoneFromComment;
    }

    //Add product
    if (_product != null) {
      order.totalAmount = _product.price.toDouble();
      order.details = <SaleOnlineOrderDetail>[];
      order.details.add(
        SaleOnlineOrderDetail(
          productId: _product.id,
          price: _product.price,
          productName: _product.name,
          uomId: _product.uOMId,
          uomName: _product.uOMName,
          quantity: productQuantity.toDouble(),
        ),
      );

      order.totalQuantity =
          _productQuantity != null ? _productQuantity.toDouble() : 0;
      order.totalAmount = (_productQuantity ?? 0) * _product.price;
    }

    order.comments = <TPosFacebookComment>[];
    final bool haveOrder = comment.saleOnlineOrder != null;
    final orderInserted = await _tposApi.insertSaleOnlineOrderFromApp(order);
    // Cập nhật hóa đơn
    await _onOrderAdded(orderInserted, notifyUi: true);
    // Check partner Id
    await _onPartnerCheckRequest(order.facebookAsuid);
    // Cập nhật khách hàng

    void exitFunction() {
      comment.setState(isBusy: false);
      comment.status = null;
    }

    // Nếu in bị tắt
    if (!_setting.isEnablePrintSaleOnline) {
      exitFunction();
      return;
    }
    // Nếu ko có hóa đơn trả về
    if (orderInserted == null) {
      exitFunction();
      return;
    }

    // Nếu ko cho phép in nhiều lần
    if (!_setting.isAllowPrintSaleOnlineManyTime) {
      if (comment.isPrinted) {
        exitFunction();
        return;
      }
    }
    if (_setting.saleOnlinePrintOnlyOneIfHaveOrder && haveOrder) {
      exitFunction();
      return;
    }

    comment.setState(isBusy: false);
    _printOrder(comment);
  }

  // Ghi có yêu cầu kiểm tra uid
  Future _onPartnerCheckRequest(String fbAsuid) async {
    final result =
        await _partnerApi.checkPartner(asuid: fbAsuid, crmTeamId: _crmTeam?.id);
    if (result.value != null && result.value.isNotEmpty) {
      final partner = result.value?.first;
      if (partner != null) {
        _onPartnerAdded(partner, partnerKey: fbAsuid);
      }
    }
  }

  /// Xảy ra khi thấy một khách hàng được thêm mới
  /// partnerKey cần thiết nếu khách hàng được tạo từ 1 comment từ page đó chính là PSUID của người nhắn
  void _onPartnerAdded(Partner partner,
      {bool notify = false, String partnerKey}) {
    var partnerComments = _comments
        .where((f) =>
            f.facebookComment.from.id == partnerKey ?? partner.facebookASids)
        .toList();
    var existsPartner = _partner.firstWhere((f) => f.partnerId == partner.id,
        orElse: () => null);

    bool isUpdate = false;
    if (existsPartner != null) {
      // update
      existsPartner.partnerName = partner.name;
      existsPartner.phone = partner.phone;
      existsPartner.partnerCode = partner.ref;
      existsPartner.address = partner.street;
      existsPartner.partnerStatus = partner.status;
      existsPartner.partnerStatusText = partner.statusText;
      existsPartner.partnerStatusStyle = partner.statusStyle;

      // Cập nhật địa chỉ mới cho đơn hàng hiện tại

      isUpdate = true;
    } else {
      // insert
      existsPartner = PartnerItemModel(
        facebookAsuid: partner.facebookASids,
        facebookUid: partner.facebookId,
        partnerId: partner.id,
        partnerCode: partner.ref,
        phone: partner.phone,
        address: partner.street,
        partnerStatus: partner.status,
        partnerStatusText: partner.statusText,
        partnerStatusStyle: partner.statusStyle,
      );
      isUpdate = false;
      _partner.add(existsPartner);
    }

    partnerComments?.forEach(
      (f) {
        if (isUpdate) {
          if (f.partnerInfo == null) f.partnerInfo = existsPartner;
          f.saleOnlineOrder?.address = existsPartner.address;
          f.notifyListeners();
        } else {
          f.partnerInfo = existsPartner;
          f.notifyListeners();
        }
      },
    );

    // Gắn vào reply comment
    final hasReplyCommnets =
        _comments.where((f) => f.comments != null && f.comments.isNotEmpty);

    if (hasReplyCommnets != null && hasReplyCommnets.isNotEmpty) {
      final replyComments = <CommentItemModel>[];
      hasReplyCommnets.forEach(
        (f) {
          replyComments.addAll(
            f.comments?.where(
              (cm) =>
                  cm.facebookComment.from.id == partnerKey ??
                  partner.facebookASids,
            ),
          );
        },
      );
      replyComments?.forEach(
        (f) {
          if (isUpdate) {
            if (f.partnerInfo == null) f.partnerInfo = existsPartner;
            f.notifyListeners();
          } else {
            f.partnerInfo = existsPartner;
            f.notifyListeners();
          }
        },
      );
    }
  }

  /// Gọi khi thấy một đơn hàng mới được thêm
  Future _onOrderAdded(SaleOnlineOrder order, {bool notifyUi = false}) async {
    var existsOrder =
        _orders.firstWhere((f) => f.id == order.id, orElse: () => null);

    bool isUpdate = false;
    if (existsOrder != null) {
      //update exist order info
      isUpdate = true;
      if (order.note != null && order.note != "") existsOrder.note = order.note;
      if (order.telephone != null && order.telephone != "")
        existsOrder.telephone = order.telephone;
      if (order.address != null && order.address != "")
        existsOrder.address = order.address;
      if (order.facebookUserId != null && order.facebookUserId != "")
        existsOrder.facebookUserId = order.facebookUserId;

      if (order.partnerCode != null && order.partnerCode != "")
        existsOrder.partnerCode = order.partnerCode;

      if (order.printCount != null && order.printCount != 0)
        existsOrder.printCount = order.printCount;
    } else {
      //insert
      _orders.add(order);
      _totalProductQuantity += (order.totalQuantity ?? 0)?.toInt();
    }
    // Check partner
    await _onPartnerCheckRequest(order.facebookAsuid);

    // Gắn vào comment
    var partnerComments = _comments
        .where((f) => f.facebookComment.from.id == order.facebookAsuid)
        .toList();
    partnerComments?.forEach(
      (f) {
        if (isUpdate) {
          if (f.saleOnlineOrder == null) f.saleOnlineOrder = order;
          f.notifyListeners();
        } else {
          f.saleOnlineOrder = order;
          f.notifyListeners();
        }
      },
    );
    // Gắn vào reply comment
    final hasReplyCommnets =
        _comments.where((f) => f.comments != null && f.comments.isNotEmpty);

    if (hasReplyCommnets != null && hasReplyCommnets.isNotEmpty) {
      final replyComments = <CommentItemModel>[];
      hasReplyCommnets.forEach(
        (f) {
          replyComments.addAll(
            f.comments?.where(
              (cm) => cm.facebookComment.from.id == order.facebookAsuid,
            ),
          );
        },
      );

      replyComments?.forEach(
        (f) {
          if (isUpdate) {
            if (f.saleOnlineOrder == null) f.saleOnlineOrder = order;
            f.notifyListeners();
          } else {
            f.saleOnlineOrder = order;
            f.notifyListeners();
          }
        },
      );
    }
  }

  /// Tìm kiếm comment
  void _onSearchComments(String keyword) {
    if (keyword == null || keyword.isEmpty) {
      _searchComments = null;
      notifyListeners();
      return;
    }
    final String keywordNoSign =
        StringUtils.removeVietnameseMark(keyword.toLowerCase());
    _searchComments = _comments
        .where(
          (f) =>
              StringUtils.removeVietnameseMark(f.facebookName.toLowerCase())
                  .contains(keywordNoSign) ||
              f.facebookComment.from.id.startsWith(keyword) ||
              getPhoneNumber(f.comment).contains(keyword) ||
              (StringUtils.removeVietnameseMark(
                      f.facebookComment.message.toLowerCase())
                  .contains(keywordNoSign.replaceAll("n:", ""))),
        )
        .toList();
    notifyListeners();
  }

  /// Lưu bình luận
  /// Chỉ có các bình luận chưa được lưu trên server sẽ được lưu lại
  Future<void> saveComment({bool showError = true}) async {
    final TposFacebookPost fbPost =
        TposFacebookPost(comment: <TPosFacebookComment>[]);

    fbPost.createdTime = facebookPost.createdTime;
    fbPost.from = TposFacebookFrom(
        id: facebookPost.from?.id,
        name: facebookPost.from?.name,
        picture: facebookPost.from?.pictureLink);
    fbPost.id = facebookPost.id;
    fbPost.message = facebookPost.message;
    fbPost.story = facebookPost.story;
    fbPost.picture = facebookPost.picture;

    fbPost.comment = _comments
        .where((f) => !_savedCommentIds.any((s) => s == f.facebookComment.id))
        .map(
          (f) => TPosFacebookComment(
              id: f.facebookComment.id,
              message: f.facebookComment.message,
              from: TposFacebookFrom(
                  id: f.facebookComment.from.id,
                  picture: f.facebookComment.from.pictureLink,
                  name: f.facebookComment.from.name),
              createdTime: f.facebookComment.createdTime),
        )
        .toList();

    if (fbPost.comment.isEmpty) {
      _dialog.showNotify(message: "Không có bình luận mới");
      return;
    }

    try {
      await _tposApi.insertFacebookPostComment([fbPost], _crmTeam.id);
      _dialog.showNotify(message: "Đã lưu ${fbPost.comment?.length} bình luận");
      //Thêm vào list đã lưu
      var commentIds = fbPost.comment.map((f) => f.id).toList();
      _savedCommentIds.addAll(commentIds);
    } catch (e, s) {
      logger.error("save comment", e, s);
      if (showError) {
        _dialog.showError(
            content: "Lưu bình luận không thành công" + e.toString());
      }
    }
  }

  Future<void> _getCommentIds() async {
    var results = await _tposApi.getCommentIdsByPostId(_facebookPost.id);

    if (results != null) {
      _savedCommentIds.addAll(results);
      logger.debug(
          "Đã có ${_savedCommentIds?.length} comment đã lưu trên server");
    }
  }

  void hideComment(CommentItemModel comment, bool isHide) async {
    try {
      await _fbApi.hiddenComment(
        commentId: comment.facebookComment.id,
        accessToken: _crmTeam.userOrPageToken,
        isHidden: isHide,
      );
      comment.facebookComment.isHidden = isHide;
      comment.notifyListeners();
    } catch (e, s) {
      logger.error("hide comment", e, s);
      _dialog.showError(
          title: "Thao tác không thành công", content: e.toString());
    }
  }

  /// Lấy bình luận trả lời
  Future<void> fetchReplyComment(CommentItemModel comment) async {
    try {
      var fetchCommentReulst = await _fbApi.fetchReplyComment(
          comment.facebookComment.id,
          accessToken: _crmTeam.userOrPageToken,
          isNewestOnTop: _setting.saleOnlineCommentDefaultOrderByOnLive ==
                  SaleOnlineCommentOrderBy.DATE_CREATE_DESC
              ? false
              : true);
      if (fetchCommentReulst.data != null) {
        comment.comments = fetchCommentReulst.data.map((f) {
          return CommentItemModel(
            facebookComment: f,
          );
        }).toList();
      }
      comment.notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
    }
  }

  void addPartner(Partner partner, CommentItemModel comment) {
    _onPartnerAdded(partner, partnerKey: comment.facebookComment.from.id);
  }

  /// Đếm số lượt bình luận của khách hàng
  int getCommentCountByFacebookAsuid(String facebookAsuid) {
    return _comments
        .where((f) => f.facebookComment.from.id == facebookAsuid)
        .length;
  }

  Future<void> _fetchTotalProductQuantity() async {
    try {
      var result = await _tposApi.getProductQuantityByPostId(_facebookPost.id);
      print(result);
      _totalProductQuantity = result ?? 0;
      notifyListeners();
    } catch (e, s) {
      logger.error("", e, s);
    }
  }

  void dispose() {
    _isCancelAll = true;
    _commentsSubscription?.cancel();
    _dataSubcription?.cancel();
    _searchSubcription?.cancel();
    _realtimeConmmentSubscription?.cancel();
    _eventSourceSubscription?.cancel();
    _timer?.cancel();
    _autoSaveCommentTimer?.cancel();
    _eventSourceSubscription?.cancel();
    _eventSource?.close();
    _realTimeCommentSubject?.close();
    _commentsSubject?.close();
    _searchCommentSubject?.close();
    _currentRealtimeMethod = RealtimeMethod.NONE;
    _realtimeMethod = RealtimeMethod.NONE;
    _currentLiveStatus = LiveStatus.VOD;
    realtimeCommentNotifySubject.close();
    super.dispose();
  }
}

class CommentItemModel extends Model {
  ISettingService _setting;
  CommentItemModel(
      {ISettingService setting,
      FacebookComment facebookComment,
      List<CommentItemModel> childs}) {
    _setting = setting ?? locator<ISettingService>();
    _facebookComment = facebookComment;
    comments = childs;
  }

  /// Store facebook commen object
  FacebookComment _facebookComment;
  PartnerItemModel partnerInfo;
  SaleOnlineOrder saleOnlineOrder;
  bool isPrinted = false;
  bool isPrintError = false;

  String _status;
  bool _isBusy = false;

  /// reply comment
  List<CommentItemModel> comments;
  FacebookComment get facebookComment => _facebookComment;

  String get facebookName => _facebookComment?.from?.name;
  String get partnerCode => partnerInfo?.partnerCode;
  String get partnerStatusText => partnerInfo?.partnerStatusText;
  String get partnerStatusStyle => partnerInfo?.partnerStatusStyle;
  String get partnerStatus => partnerInfo?.partnerStatus;
  String get comment => _facebookComment?.message;
  bool get isHidden => _facebookComment?.isHidden ?? false;

  ///Return index session and order number
  String get orderCode {
    if (saleOnlineOrder != null &&
        saleOnlineOrder.sessionIndex != null &&
        saleOnlineOrder.sessionIndex != 0) {
      return "#${saleOnlineOrder.sessionIndex}. ${saleOnlineOrder.code}";
    } else {
      return saleOnlineOrder?.code;
    }
  }

  bool get isHasPhone => partnerInfo?.hasPhone ?? false;
  bool get isHasAddress => partnerInfo?.hasAddress ?? false;
  bool get isHasInfo =>
      partnerInfo != null || isHasPhone || isHasAddress || orderCode != null;

  String get partnerPhone => partnerInfo?.phone;

  String get partnerAvata => _facebookComment.from.pictureLink;
  String get commentTime {
    return _setting.isSaleOnlineViewTimeAgoOnLiveComment
        ? time_ago.format(_facebookComment.createdTime, locale: "vi_short")
        : DateFormat(
                "${DateTime.now().day != _facebookComment.createdTime.day ? "dd/MM/yyyy HH:mm:ss" : "HH:mm:ss"}")
            .format(_facebookComment.createdTime.toLocal());
  }

  bool get isBusy => _isBusy;
  String get status => _status;

  set status(String value) {
    _status = value;
    notifyListeners();
  }

  set isBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  void setState({bool isBusy, String message}) {
    _isBusy = isBusy;
    _status = message;
    notifyListeners();
  }
}

class PartnerItemModel extends Model {
  int partnerId;
  String partnerName;
  String partnerCode;
  String phone;
  String address;
  String partnerStatus;
  String partnerStatusText;
  String partnerStatusStyle;
  String facebookUid;
  String facebookAsuid;

  PartnerItemModel(
      {this.partnerId,
      this.partnerName,
      this.partnerCode,
      this.phone,
      this.address,
      this.partnerStatus,
      this.partnerStatusText,
      this.partnerStatusStyle,
      this.facebookUid,
      this.facebookAsuid});

  bool get hasPhone => phone != null && phone != "";
  bool get hasAddress => address != null && address != "";
}

List<CommentItemModel> _mapFacebookCommentsToCommentItemModels(
    List<FacebookComment> facebookComments) {
  return facebookComments
      .map(
        (f) => CommentItemModel(
          facebookComment: f,
          childs: f.comments != null
              ? _mapFacebookCommentsToCommentItemModels(f.comments)
              : null,
        ),
      )
      .toList();
}

CommentItemModel _mapFacebookCommenttoCommentItemModel(
    FacebookComment facebookComment) {
  return CommentItemModel(
    facebookComment: facebookComment,
  );
}

enum RealtimeMethod {
  AUTO,
  MANUAL,
  EVENT_SOURCE,
  DURATION,
  EVENT_SOURCE_AND_DURATION,
  NONE,
  NOT_SET,
}
