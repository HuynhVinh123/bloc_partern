import 'package:scoped_model/scoped_model.dart';

class ViewModelCommand extends Model {
  String name;
  String description;
  Function(Object) executeFunction;
  Function(Object) canExecute;
  Function(Object) enable;
  Function(Object) visible;

  bool _isVisible = true;
  bool _isCanExecute = true;
  bool _isEnable = true;
  Object _param;
  bool _isExecuting = false;
  bool get isExecuting => _isExecuting;
  bool get isVisible {
    if (visible != null) _isVisible = visible(_param);
    return _isVisible;
  }

  bool get isCanExecute {
    if (canExecute != null) {
      _isCanExecute = canExecute(_param);
    }

    return _isCanExecute;
  }

  bool get isEnable {
    if (enable != null) _isEnable = enable(_param);
    return _isEnable;
  }

  ViewModelCommand(
      {this.name,
      this.description,
      this.executeFunction,
      this.canExecute,
      this.enable,
      this.visible});

  Future<Object> execute(Object param) async {
    _isExecuting = true;
    notifyListeners();
    this._param = param;
    if (this.isVisible && this.isEnable && this.isCanExecute) {
      var result = await executeFunction(_param);
      _isExecuting = false;
      notifyListeners();
      return result;
    }
    _isExecuting = false;
    notifyListeners();
    return null;
  }
}
