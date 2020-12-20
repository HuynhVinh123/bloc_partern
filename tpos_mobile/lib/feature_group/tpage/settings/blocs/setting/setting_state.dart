class SettingState {}

/// Loading
class SettingLoading extends SettingState {}

/// State khi load dữ liệu thành công
class SettingLoadSuccess extends SettingState {}

/// State khi thực thi 1 hành động thêm, sửa, xóa thành công
class ActionSuccess extends SettingState {
  ActionSuccess({this.title, this.content});
  final String title;
  final String content;
}

/// State khi thực thi load dữ liệu thất bại
class SettingLoadFailure extends SettingState {
  SettingLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
