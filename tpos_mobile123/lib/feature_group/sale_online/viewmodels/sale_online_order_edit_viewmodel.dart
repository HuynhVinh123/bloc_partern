/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 4:31 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 3:12 PM
 *
 */

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/helpers/string_helper.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/helpers.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/cache_service.dart';
import 'package:tpos_mobile/services/data_services/data_service.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/services/print_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/CheckAddress.dart';

import 'package:tpos_mobile/src/tpos_apis/models/sale_online_facebook_comment.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';

import 'new_facebook_post_comment_viewmodel.dart';

class SaleOnlineEditOrderViewModel extends ViewModel implements ViewModelBase {
  SaleOnlineEditOrderViewModel(
      {ISettingService settingService,
      ITposApiService tposApi,
      DataService dataService,
      PartnerApi partnerApi,
      PrintService print,
      DialogService dialog,
      CacheService cacheService}) {
    _settingService = settingService ?? locator<ISettingService>();
    _tposApi = tposApi ?? locator<ITposApiService>();
    _print = print ?? locator<PrintService>();
    _partnerApi = partnerApi ?? GetIt.I<PartnerApi>();
    _dataService = dataService ?? locator<DataService>();
    _dialog = dialog ?? locator<DialogService>();
    _cacheService = cacheService ?? GetIt.instance<CacheService>();

    onStateAdd(false);
  }
  //log
  final _log = Logger("SaleOnlineEditOrderViewModel");

  ISettingService _settingService;
  ITposApiService _tposApi;
  PartnerApi _partnerApi;
  PrintService _print;
  DataService _dataService;
  DialogService _dialog;
  CacheService _cacheService;

  // Param
  CRMTeam _crmTeam;
  //editOrder
  SaleOnlineOrder _editOrder;
  String _editOrderId;
  CommentItemModel _comment;
  String _facebookPostId;
  SaleOnlineOrder get editOrder => _editOrder;
  String get editOrderId => _editOrderId;
  Product _product;
  LiveCampaign _liveCampaign;
  double _productQuantity;

  set editOrder(SaleOnlineOrder value) {
    _editOrder = value;
    _editOrderController.add(value);
  }

  final BehaviorSubject<SaleOnlineOrder> _editOrderController =
      BehaviorSubject();
  Stream<SaleOnlineOrder> get editOrderStream => _editOrderController.stream;
  Sink<SaleOnlineOrder> get editOrderSink => _editOrderController.sink;

  //Parnter
  Partner _partner;
  Partner get partner => _partner;

  set partner(Partner value) {
    _partner = value;
    _partnerController.add(_partner);
  }

  final BehaviorSubject<Partner> _partnerController = BehaviorSubject();
  Stream<Partner> get parterStream => _partnerController.stream;

  // List<CheckAddress>
  List<CheckAddress> _checkAddressResults;
  List<CheckAddress> get checkAddressResults => _checkAddressResults;
  set checkAddressResults(List<CheckAddress> value) {
    _checkAddressResults = value;
    _checkAddressResultsController.add(value);
  }

  final BehaviorSubject<List<CheckAddress>> _checkAddressResultsController =
      BehaviorSubject();
  Stream<List<CheckAddress>> get checkAddressResultStream =>
      _checkAddressResultsController.stream;

  // SelectedAddress
  CheckAddress _selectedCheckAddress;
  CheckAddress get selectedCheckAddress => _selectedCheckAddress;
  set selectedCheckAddress(CheckAddress value) {
    _selectedCheckAddress = value;
    _selectedCheckAddressController.add(value);
    _checkAddressResultsController.add(_checkAddressResults);
  }

  final BehaviorSubject<CheckAddress> _selectedCheckAddressController =
      BehaviorSubject();
  Stream<CheckAddress> get selectedCheckAddressStream =>
      _selectedCheckAddressController.stream;

  // recentComments Bình luận gần đây

  List<SaleOnlineFacebookComment> _recentComments;
  List<SaleOnlineFacebookComment> get recentComments => _recentComments;
  final BehaviorSubject<List<SaleOnlineFacebookComment>>
      _recentCommentsController = BehaviorSubject();
  BehaviorSubject<List<SaleOnlineFacebookComment>>
      get recentCommentsObservable => _recentCommentsController.stream;
  void _recentCommentsAdd(List<SaleOnlineFacebookComment> values) {
    _recentComments = values;
    if (_recentCommentsController.isClosed == false) {
      _recentCommentsController.add(_recentComments);
    }
  }

  Future init(
      {SaleOnlineOrder editOrder,
      String orderId,
      String facebookPostId,
      @required CommentItemModel comment,
      CRMTeam crmTeam,
      Product product,
      LiveCampaign liveCampaign,
      double productQuantity}) async {
    assert(orderId != null || editOrder != null || comment != null);

    _comment = comment;
    _editOrderId = orderId ?? editOrder?.id;
    _editOrder = editOrder;
    _facebookPostId = facebookPostId;
    _crmTeam = crmTeam;
    _product = product;
    _liveCampaign = liveCampaign;
    _productQuantity = productQuantity;

    onIsBusyAdd(false);
  }

  Future<void> initData() async {
    onStateAdd(true);
    if (_editOrderId != null) {
      await loadOrderInfo();
    } else {
      _editOrder = SaleOnlineOrder();
      if (_comment != null) {
        _editOrder.telephone = getPhoneNumber(_comment.comment);
        _editOrder.name = _comment.facebookName;
      }
    }

    await loadRecentCommentsCommand();
    if (_editOrderController.isClosed == false)
      _editOrderController.add(_editOrder);
    onStateAdd(false);
  }

  double get totalAmount {
    if (editOrder != null &&
        editOrder.details != null &&
        editOrder.details.isNotEmpty) {
      final double sum = editOrder.details
          .map((f) => f.price * f.quantity)
          .reduce((d1, d2) => d1 + d2);
      return sum;
    } else {
      return 0;
    }
  }

  Future loadOrderInfo() async {
    try {
      editOrder = await _tposApi.getOrderById(_editOrderId);
      partner = await _partnerApi.getById(editOrder.partnerId);
    } catch (ex, stack) {
      _log.severe("loadOrderInfo fail", ex, stack);
      _dialog.showError(error: ex, title: 'Đã xảy ra lỗi');
    }
  }

  /// Kiểm tra địa chỉ nhanh
  Future checkAddress({String keyword}) async {
    try {
      checkAddressResults = await _tposApi.checkAddress(keyword);
      selectedCheckAddress = checkAddressResults.first;
      // Tự thay địa chỉ đã chọn
      if (selectedCheckAddress != null) {
        fillCheckAddress(selectedCheckAddress);
      }
    } catch (ex, stack) {
      _log.severe("checkAddress fail", ex, stack);
      _dialog.showError(error: ex, title: 'Đã xảy ra lỗi');
    }
  }

  void fillCheckAddress(CheckAddress checkAddress) {
    editOrder.cityCode = checkAddress.cityCode;
    editOrder.cityName = checkAddress.cityName;
    editOrder.districtCode = checkAddress.districtCode;
    editOrder.districtName = checkAddress.districtName;
    editOrder.wardCode = checkAddress.wardCode;
    editOrder.wardName = checkAddress.wardName;
    editOrder.address = checkAddress.address;
    editOrderSink.add(_editOrder);
  }

  Future<void> selectDropDownAddress(CheckAddress newValue) async {
    selectedCheckAddress = newValue;
  }

  /// Lưu đơn hàng
  Future save() async {
    try {
      if (editOrder.id != null) {
        // editOrder.companyId = _applicationVM.company.id; // TODO(namnv): Chú ý chỗ này

        editOrder.companyId = _cacheService.companyCurrent.companyId;
        await _tposApi.updateSaleOnlineOrder(editOrder);
        editOrder.totalAmount = totalAmount;

        _dialog.showNotify(message: 'Đã lưu đơn hàng');
        _dataService.addDataNotify(
            sender: this, value: editOrder, type: DataMessageType.UPDATE);
      } else {
        await createSaleOnlineOrderCommand();
      }
    } catch (ex, stack) {
      _log.severe("save fail", ex, stack);
      _dialog.showError(error: ex, title: 'Đã xảy ra lỗi');
    }
  }

  // Tạo đơn hàng
  Future<void> createSaleOnlineOrderCommand() async {
    assert(_crmTeam.id != null);
    assert(_facebookPostId != null);
    assert(_comment != null);
    onStateAdd(true);
    // check facebook id
    CheckFacebookIdResult checkResult;
    try {
      checkResult = await _tposApi.checkFacebookId(
          _editOrder.facebookAsuid, editOrder.facebookPostId, _crmTeam?.id);
    } catch (ex, s) {
      _log.severe("createSaleOnlineOrder", ex, s);
    }

    if (checkResult != null) {
      if (checkResult.customers != null && checkResult.customers.isNotEmpty) {
        editOrder.partnerId = checkResult.customers.first.id;
      }
    }

    SaleOnlineOrder result;
    try {
      // update full data
      editOrder.crmTeamId = _crmTeam.id;
      editOrder.facebookPostId = _facebookPostId;
      editOrder.facebookUserName = _comment.facebookComment.from.name;
      editOrder.facebookAsuid = _comment.facebookComment.from.id;
      editOrder.facebookCommentId = _comment.facebookComment.id;

      editOrder.liveCompaignId = _liveCampaign?.id;
      editOrder.liveCampaignName = _liveCampaign?.name;
      editOrder.name = editOrder.facebookUserName;
      editOrder.note = "";
      if (_settingService.isSaleOnlinePrintComment) {
        editOrder.note = _comment.comment;
      }

      /// Add new phone
      final String phoneFromComment = getPhoneNumber(_comment.comment);
      if (phoneFromComment != null && phoneFromComment != "") {
        editOrder.telephone = phoneFromComment;
      }

      //Add product
      if (_product != null) {
        editOrder.totalAmount = _product.price.toDouble();
        editOrder.details = <SaleOnlineOrderDetail>[];
        editOrder.details.add(
          SaleOnlineOrderDetail(
            productId: _product.id,
            price: _product.price,
            productName: _product.name,
            uomId: _product.uOMId,
            uomName: _product.uOMName,
            quantity: _productQuantity?.toDouble(),
          ),
        );

        editOrder.totalQuantity =
            _productQuantity != null ? _productQuantity.toDouble() : 0;
        editOrder.totalAmount = (_productQuantity ?? 0) * _product.price;
      }

      result = await _tposApi.insertSaleOnlineOrderFromApp(editOrder);

      // notify object changed
      _dataService.addDataNotify(
          sender: this, value: result, type: DataMessageType.INSERT);
    } catch (e, s) {
      _log.severe("", e, s);
      _dialog.showError(error: e, title: 'Đã xảy ra lỗi');
    }

    if (result != null) {
      if (_settingService.isEnablePrintSaleOnline) {
        // In phiếu

        try {
          await _print.printSaleOnlineTag(
              order: result,
              partnerStatus: _partner?.statusText,
              comment: _comment?.comment,
              productName: _product?.name,
              isPrintNode: _settingService.saleOnlinePrintAllNoteWhenPreprint);
        } catch (e, s) {
          _dialog.showError(error: e, title: 'Không in được phiếu');
          _log.severe("createdSaleOnlineOrder- print", e, s);
        }
      }
    }

    onStateAdd(false);
  }

  Future<void> loadRecentCommentsCommand() async {
    final String facebookAsuid =
        _comment?.facebookComment?.from?.id ?? editOrder?.facebookAsuid;

    final String facebookPostId = _editOrder?.facebookPostId ?? _facebookPostId;
    if (facebookAsuid == null) {
      _log.severe("FacebookAsuid is null and comment not load");
      return;
    }
    try {
      _recentComments = await _tposApi.getCommentsByUserAndPost(
          userId: facebookAsuid, postId: facebookPostId);
      _recentCommentsAdd(_recentComments);
    } catch (e, s) {
      _log.severe("loadRecentCommentsCommand", e, s);
      _dialog.showNotify(
        message: 'Không tải được bình luận gần đây',
        type: DialogType.NOTIFY_ERROR,
      );
    }
  }

  /// In phiếu sale online
  Future printSaleOnlineTag() async {
    onIsBusyAdd(true);
    try {
      await _print.printSaleOnlineTag(
          order: _editOrder,
          partnerStatus: _partner?.statusText,
          isPrintNode: _settingService.saleOnlinePrintAllNoteWhenPreprint);
      _dialog.showNotify(
        message: 'Đã in phiếu',
        type: DialogType.NOTIFY,
      );
    } catch (ex, stack) {
      _log.severe("printSaleOnlineTag fail", ex, stack);
      _dialog.showError(error: ex, title: 'Không in được phiếu');
    }
    onIsBusyAdd(false);
  }

  Future updateParterStatus(String status, String statusText) async {
    try {
      await _partnerApi.updateStatus(partner.id,
          status: "${status}_$statusText}");
      partner.status = status;
      partner.statusText = statusText;
    } catch (ex, stack) {
      _log.severe("updateParterStatus fail", ex, stack);
      _dialog.showError(
          error: ex, title: 'Không cập nhật được trạng thái khách hàng');
    }

    partner = partner;
  }

  @override
  void dispose() {
    _editOrderController.close();
    _selectedCheckAddressController.close();
    _checkAddressResultsController.close();
    _recentCommentsController.close();
    super.dispose();
  }
}
