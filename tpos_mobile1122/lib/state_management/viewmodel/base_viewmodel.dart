import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';

/// ViewModel using [ChangeNotifier] of [Provider] for notify property change to the UI and using RxDart BehaviorSubject to
/// store state of [ViewModel]
/// * State of ViewModel (Initial, Loading, LoadSuccess, LoadFailure)
abstract class PViewModel with ChangeNotifier {
  final Logger _logger = Logger();
  final PublishSubject<PViewModelState> _stateSubject =
      PublishSubject<PViewModelState>();
  Stream<PViewModelState> get stateStream => _stateSubject.stream;

  /// Khởi tạo dữ liệu khi [ViewModel] được [Contructor]
  /// Trạng thái hiện tại
  PViewModelState state;
  void init();
  Future<PCommandResult> initData();

  /// Thay đổi trạng thái cho ViewModel
  void setState([PViewModelState state]) {
    if (_stateSubject != null && !_stateSubject.isClosed) {
      _stateSubject.add(state);
    }
    this.state = state;
    notifyListeners();
    _logger.i('$runtimeType | state changed | $state');
  }

  @mustCallSuper
  void dispose() {
    _stateSubject.close();
    super.dispose();
  }
}

class PCommandResult {
  PCommandResult(this.success) {
    if (kDebugMode) {
      print('PCommandResult($success)');
    }
  }
  final bool success;
}

abstract class PListViewModel extends PViewModel {}

/// Default ViewModelState
abstract class PViewModelState {}

class PViewModelLoading extends PViewModelState {
  PViewModelLoading([this.message]);
  final String message;
}

class PViewModelBusy extends PViewModelState {
  PViewModelBusy([this.message]);
  final String message;
}

class PViewModelLoadSuccess extends PViewModelState {}

class PViewModelLoadFailure extends PViewModelState {
  final String mesage;

  PViewModelLoadFailure(this.mesage);
}

class PViewModelActionSuccess extends PViewModelState {}

class PViewModelActionFailure extends PViewModelState {}

class PViewModelValidateFailure extends PViewModelState {
  PViewModelValidateFailure(this.message);
  final String message;
}
