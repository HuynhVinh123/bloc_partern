class TagCategoryAddEditState {}

class InitLoading extends TagCategoryAddEditState{}

class TagCategoryAddEditLoading extends TagCategoryAddEditState{}

class TagCategoryAddEditActionSuccess extends TagCategoryAddEditState{
  TagCategoryAddEditActionSuccess({this.message, this.title});
  final String title;
  final String message;
}

class TagCategoryAddEditActionFailure extends TagCategoryAddEditState{
  TagCategoryAddEditActionFailure({this.message, this.title});
  final String title;
  final String message;
}