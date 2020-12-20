class TagCategoryAddEditState {}

/// State loading khi mới vào trang
class InitLoading extends TagCategoryAddEditState {}

/// State loading khi thực hiện cập nhât, thêm
class TagCategoryAddEditLoading extends TagCategoryAddEditState {}

/// State khi cập nhật, xóa thành công
class TagCategoryAddEditActionSuccess extends TagCategoryAddEditState {
  TagCategoryAddEditActionSuccess({this.message, this.title});
  final String title;
  final String message;
}

/// State khi cập nhât, thêm thất bại
class TagCategoryAddEditActionFailure extends TagCategoryAddEditState {
  TagCategoryAddEditActionFailure({this.message, this.title});
  final String title;
  final String message;
}
