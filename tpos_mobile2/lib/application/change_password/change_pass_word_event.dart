class ChangePassWordEvent {}

class ChangePassWordLoaded extends ChangePassWordEvent {
  ChangePassWordLoaded(
      {this.confirmPassWord, this.newPassword, this.oldPassword});
  final String oldPassword;
  final String newPassword;
  final String confirmPassWord;
}
