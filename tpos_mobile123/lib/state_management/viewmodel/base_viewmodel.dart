import 'package:flutter/cupertino.dart';

abstract class ViewModel with ChangeNotifier {
  /// Khởi tạo dữ liệu khi [ViewModel] được [Contructor]
  void init();

  /// Khởi tạo dữ liêu. Như lấy data từ server...
  Future<void> start();

  /// Hủy bỏ và giải phòng dữ liệu
  void dispose();
}

abstract class ListViewModel with ChangeNotifier {}

class ViewModelState {}
