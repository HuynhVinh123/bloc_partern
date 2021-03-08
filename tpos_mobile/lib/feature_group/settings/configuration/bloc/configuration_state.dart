abstract class MobileConfigState {}

class MobileConfigLoadSuccess extends MobileConfigState {
  MobileConfigLoadSuccess(
      {this.username,
      this.url,
      this.deviceBranch,
      this.deviceModel,
      this.loginUsername});

  final String deviceBranch;
  final String deviceModel;
  final String loginUsername;

  final String username;
  final String url;
}

class MobileConfigValidateSuccess extends MobileConfigState {
  MobileConfigValidateSuccess(this.showWarning);
  final bool showWarning;
}

class ConfigurationBusy extends MobileConfigState {}

class ConfigurationLoading extends MobileConfigState {}

class ConfigurationUploadSuccess extends MobileConfigState {}

class ConfigurationServerLoadSuccess extends MobileConfigState {}

class ConfigurationDeviceSelectSuccess extends MobileConfigState {}

class ConfigurationError extends MobileConfigState {
  ConfigurationError({this.error});

  final String error;
}

class ConfigurationLoadFailure extends MobileConfigState {
  ConfigurationLoadFailure({this.error});

  final String error;
}
