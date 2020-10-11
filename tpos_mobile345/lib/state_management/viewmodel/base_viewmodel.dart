import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

/// ViewModel using [ChangeNotifier] of [Provider] for notify property change to the UI and using RxDart BehaviorSubject to
/// store state of [ViewModel]
/// * State of ViewModel (Initial, Loading, LoadSuccess, LoadFailure)
abstract class PViewModel<T> with ChangeNotifier {
  final Logger _logger = Logger();
  final PublishSubject<T> _stateSubject = PublishSubject<T>();

  /// Khởi tạo dữ liệu khi [ViewModel] được [Contructor]
  /// Trạng thái hiện tại
  T state;

  void init();

  /// Khởi tạo dữ liêu. Như lấy data từ server...
  Future<void> start();

  /// Thay đổi trạng thái cho ViewModel
  void setState([T state]) {
    if (_stateSubject != null && !_stateSubject.isClosed) {
      _stateSubject.add(state);
    }
    this.state = state;
    notifyListeners();
    _logger.i('$runtimeType | state changed | $state');
  }

  void dispose() {
    _stateSubject.close();
    super.dispose();
  }
}

abstract class PListViewModel extends PViewModel {}

/// Default ViewModelState
abstract class PViewModelState {}

class PViewModelLoading extends PViewModelState {}

class PViewModelLoadSuccess extends PViewModelState {}

class PViewModelLoadFailure extends PViewModelState {}

class PViewModelActionSuccess extends PViewModelState {}

class PViewModelActionFailure extends PViewModelState {}

class PViewModelValidateFailure extends PViewModelState {
  PViewModelValidateFailure(this.message);
  final String message;
}
