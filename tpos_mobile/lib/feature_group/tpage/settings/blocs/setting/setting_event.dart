class SettingEvent {}

///Event lấy thông tin dữ liệu
class SettingLoaded extends SettingEvent {}

/// Event xóa thông tin dữ liệu
class SettingDeleted extends SettingEvent {
  SettingDeleted({this.id});
  final String id;
}

/// Event thực thi cập nhật thông tin dữ liệu
class SettingUpdated extends SettingEvent {
  SettingUpdated({this.products});
  final String products;
}

/// Event thực thi thêm dữ liệu
class SettingAdded extends SettingEvent {
  SettingAdded({this.reply});
  final String reply;
}
