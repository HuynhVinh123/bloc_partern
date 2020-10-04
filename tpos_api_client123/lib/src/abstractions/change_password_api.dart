abstract class ChangePasswordApi {
  Future<bool> doChangeUserPassWord(
      {String oldPassword, String newPassword, String confirmPassWord});
}
