abstract class HomeState {}

/// Chưa khởi tạo
class HomeUnInitial extends HomeState {}

/// Đang tải dữ liệu
class HomeLoading extends HomeState {}

/// Đang bận
class HomeBusy extends HomeState {}

/// Tải dữ liệu thành công
class HomeLoadSuccess extends HomeState {
  HomeLoadSuccess({this.menuIndex, this.isExprired, this.expriredTime});
  final int menuIndex;
  final bool isExprired;
  final String expriredTime;
}

/// Tải dữ liệu thất bại
class HomeLoadFailure extends HomeState {
  HomeLoadFailure(this.message);
  final dynamic message;
}

class HomeRequestLogout extends HomeState {}
