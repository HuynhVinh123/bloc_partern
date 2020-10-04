class ChangePasswordState {}

class ChangePasswordInitialLoading extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  ChangePasswordFailure({this.content, this.title});
  final String title;
  final String content;
}
