/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 4/9/19 9:59 AM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 4/9/19 9:52 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOrderUserViewModel extends ViewModel {
  SaleOrderUserViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  //log
  final _log = Logger("SaleOrderUserViewModel");
  ITposApiService _tposApi;


  // List Selected Partner Category
  List<ApplicationUser> selectedUser;

  // List Partner Category
  List<ApplicationUser> _users;
  List<ApplicationUser> tempUsers;
  List<ApplicationUser> get users => _users;
  set users(List<ApplicationUser> value) {
    _users = value;
    _usersController.add(_users);
  }

  final BehaviorSubject<List<ApplicationUser>> _usersController =
      BehaviorSubject();
  Stream<List<ApplicationUser>> get usersStream => _usersController.stream;

  // Key word
  String _keyword = "";
  String get keyword => _keyword;
  set keyword(String value) {
    _keyword = value;
    notifyListeners();
  }

  Future<void> searchOrderCommand(String value) async {
    keyword = value;
    onSearchingOrderHandled(keyword);
    notifyListeners();
  }

  Future<void> onSearchingOrderHandled(String keyword) async {
    if (keyword == null || keyword == "") {
      users = tempUsers;
      notifyListeners();
    }
    try {
      final String key = StringUtils.removeVietnameseMark(keyword);
      users = tempUsers
          .where((f) => f.name != null
              ? StringUtils.removeVietnameseMark(f.name.toLowerCase())
                  .contains(key.toLowerCase())
              : false)
          .toList();
      notifyListeners();
    } catch (ex) {
      onDialogMessageAdd(OldDialogMessage.error("", ex.toString()));
    }
  }

  Future loadPartnerCategory() async {
    try {
      final result = await _tposApi.getApplicationUsersSaleOrder(keyword);
      users = result.value;
      tempUsers = users;
    } catch (ex, stack) {
      _log.severe("loadUsers fail", ex, stack);
    }
  }

  Future init() async {
    await loadPartnerCategory();
  }

}
