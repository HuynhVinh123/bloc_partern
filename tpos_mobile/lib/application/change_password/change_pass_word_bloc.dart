import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'change_pass_word_event.dart';
import 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePassWordEvent, ChangePasswordState> {
  ChangePasswordBloc({ChangePasswordApi changePasswordApi})
      : super(ChangePasswordInitialLoading()) {
    _apiClient = changePasswordApi ?? GetIt.instance<ChangePasswordApi>();
  }

  ChangePasswordApi _apiClient;

  @override
  Stream<ChangePasswordState> mapEventToState(event) async* {
    if (event is ChangePassWordLoaded) {
      yield ChangePasswordLoading();
      try {
        final result = await _apiClient.doChangeUserPassWord(
            oldPassword: event.oldPassword,
            newPassword: event.newPassword,
            confirmPassWord: event.confirmPassWord);
        if (result) {
          yield ChangePasswordSuccess();
        } else {
          yield ChangePasswordFailure(
              title: S.current.changePassword_changeFailed,
              content: S.current.changePassword_tryToAgain);
        }
      } catch (e) {
        yield ChangePasswordFailure(
            title: S.current.changePassword_changeFailed,
            content: e.toString());
      }
    }
  }
}
