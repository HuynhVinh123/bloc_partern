/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 9:23 AM
 *
 */

import 'dart:async';

import 'package:logging/logging.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/sale_facebook_user_viewmodel.dart';
import 'package:tpos_mobile/src/facebook_apis/facebook_api.dart';

class SaleFacebookCommentViewModel implements ViewModelBase {
  SaleFacebookCommentViewModel(
      {this.comment, SaleFacebookUserViewModel facebookUser, this.comments}) {
    _facebookUser = facebookUser;
    isBusy = false;
  }
  //log
  final log = Logger("SaleFacebookCommentViewModel");
  FacebookComment comment;

  //facebookUser
  SaleFacebookUserViewModel _facebookUser;
  SaleFacebookUserViewModel get facebookUser => _facebookUser;

  final BehaviorSubject<SaleFacebookUserViewModel> _facebookUserController =
      BehaviorSubject();
  Stream<SaleFacebookUserViewModel> get facebookUserStream =>
      _facebookUserController.stream;

  set facebookUser(SaleFacebookUserViewModel value) {
    _facebookUser = value;
    if (_facebookUserController.isClosed == false)
      _facebookUserController.add(value);
  }

  bool _isShowMoreFunction = false;
  bool get isShowMoreFunction => _isShowMoreFunction;
  set isShowMoreFunction(bool value) {
    _isShowMoreFunction = !_isShowMoreFunction;
    if (notifyListennerController.isClosed == false) {
      notifyListennerController.add(true);
    }
  }

  //Status
  String _status = "";
  String get status => _status;

  final BehaviorSubject<String> _statusController = BehaviorSubject();
  Stream<String> get statusStream => _statusController.stream;
  set status(String value) {
    _status = value;
    if (_statusController.isClosed == false) {
      _statusController.add(value);
    }
  }

  // IsBusy
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  final BehaviorSubject<bool> _isBusyController = BehaviorSubject();
  Stream<bool> get isBusyStream => _isBusyController.stream;

  set isBusy(bool value) {
    _isBusy = value;
    if (_isBusyController.isClosed == false) {
      _isBusyController.add(value);
    }
  }

  List<SaleFacebookCommentViewModel> comments =
      <SaleFacebookCommentViewModel>[];

  bool get isCreatedOrder {
    if (facebookUser != null &&
        facebookUser.orderNumber != null &&
        facebookUser.orderNumber.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool isPrintTag = false;

  BehaviorSubject<bool> notifyListennerController = BehaviorSubject();
  Stream<bool> get notifyListennerStream => notifyListennerController.stream;

  @override
  void dispose() {
    notifyListennerController.close();
    _facebookUserController.close();
    _isBusyController.close();
    _statusController.close();
  }
}
