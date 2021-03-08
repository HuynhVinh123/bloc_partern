/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/4/19 6:25 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/4/19 3:20 PM
 *
 */

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';

abstract class ViewModelBase {
  void dispose() {}
}

/// ViewModel base using ScopedModel for notify change to the UI
@Deprecated(
    'ViewModel này đã cũ. Sử dụng [ProviderViewModel] hoặc Bloc thay thế')
class ScopedViewModel extends Model implements ViewModelBase {
  ScopedViewModel({LogService logService}) {
    _log = logService ?? locator<LogService>();
  }
  bool _isBusy = false;
  bool get isBusy => _isBusy;
  bool isInit = false;
  bool isInitData = false;
  LogService _log;

  LogService get logger => _log;

  ViewModelState _viewModelState;
  ViewModelState get state => _viewModelState;
  @Deprecated('This method will deprecated in a future')
  PublishSubject<String> notifyPropertyChangedController =
      PublishSubject<String>();

  /// Deprecated object
  @Deprecated('This subject will be deprecated in the future')
  PublishSubject<OldDialogMessage> dialogMessageController =
      PublishSubject<OldDialogMessage>();

  BehaviorSubject<bool> isBusyController = BehaviorSubject<bool>();
  BehaviorSubject<String> viewModelStatusController = BehaviorSubject();

  BehaviorSubject<ViewModelState> stateController = BehaviorSubject();
  BehaviorSubject<ViewModelEvent> eventController =
      BehaviorSubject<ViewModelEvent>();

  @Deprecated('This method will deprecated in a future')
  void onPropertyChanged(String name) {
    if (!notifyPropertyChangedController.isClosed) {
      notifyPropertyChangedController.sink.add(name);
      print("***On PropertyChanged " + name);
    }
  }

  void onStatusAdd(String value) {
    if (viewModelStatusController != null &&
        viewModelStatusController.isClosed == false) {
      viewModelStatusController.add(value);
    }
  }

  @Deprecated("Hàm này sẽ sớm ngừng hoạt động trong tương lai")
  void onDialogMessageAdd(OldDialogMessage message) {
    if (!dialogMessageController.isClosed) {
      dialogMessageController.sink.add(message);
    }
  }

  @Deprecated(
      "Hàm này sẽ sớm ngừng hoạt động trong tương lai. Thay thế bằng setBusy")
  void onIsBusyAdd(bool value) {
    _isBusy = value;
    if (!isBusyController.isClosed) {
      isBusyController.add(value);
    }
  }

  void setBusy(bool isBusy, {String message = "", bool isError = false}) {
    _viewModelState =
        ViewModelState(isBusy: isBusy, message: message, isError: isError);

    onIsBusyAdd(isBusy);
    onStatusAdd(message);

    if (!stateController.isClosed) {
      stateController.add(_viewModelState);
    }
  }

  /// Ghi nhận sự kiện xuất phát từ Viewmodel
  /// Các sự kiện có thể là sự kiện nội bộ giữa Viewmodel và view hoặc sự kiện publish toàn phần mềm
  void onEventAdd(String eventName, Object param,
      {bool isAnalyticEvent, bool isGlobalEvent}) {
    if (eventController != null && eventController.isClosed == false) {
      eventController.add(ViewModelEvent(eventName: eventName, param: param));
      _log.debug('VIEWMODEL EVENT [$eventName] ADDED with param [$param]');
    }
  }

  /// Thêm giá trị vào BehaverSubject một cách an toàn
  void addSubject<T>(Subject<T> subject, T value) {
    if (subject != null && subject.isClosed == false) {
      subject.add(value);
    }
  }

  /// Thêm lỗi vào BehaverSbject một cách an toàn
  void addErrorSubject<T>(Subject<T> subject, Object e, [StackTrace s]) {
    if (subject != null && subject.isClosed == false) {
      subject.addError(e, s);
    }
  }

  /// Override dispose. Must call on UI to dispose resource.
  @mustCallSuper
  @override
  void dispose() {
    notifyPropertyChangedController.close();
    dialogMessageController.close();
    isBusyController.close();
    stateController.close();
    viewModelStatusController.close();
    eventController.close();
  }
}

class ViewModelState {
  ViewModelState({this.message, this.isBusy = false, this.isError = false});
  ViewModelState.error(String message) {
    isBusy = false;
    isError = true;
    message = message;
  }
  String message;
  bool isBusy;
  bool isError;
}

class ViewModelEvent {
  ViewModelEvent({this.eventName, this.param});
  String eventName;
  Object param;
}

// class ViewModelPageSate {}
//
// class ViewModelPageLoading extends ViewModelPageSate {}
//
// class ViewModelPageLoadSuccess extends ViewModelPageSate {}
//
// class ViewModelPageLoadFailure extends ViewModelPageSate {}
