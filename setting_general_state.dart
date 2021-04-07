import 'package:tdental_api_client/models/entities/res_config_setting.dart';

abstract class SettingGeneralState {}

class SettingGeneralLoading extends SettingGeneralState {}

class SettingGeneralSuccess extends SettingGeneralState {
  SettingGeneralSuccess(
      {required this.resConfigSetting,
      required this.titles,
      required this.checkCompanies});

  final ResConfigSetting resConfigSetting;
  final List<Map<String, dynamic>> titles;
  final List<Map<String, dynamic>> checkCompanies;
}

class SettingGeneralInsertFailure extends SettingGeneralState {
  SettingGeneralInsertFailure({required this.title, required this.content});
  final String title;
  final String content;
}

class SettingGeneralInsertSuccess extends SettingGeneralState {
  SettingGeneralInsertSuccess({required this.title, required this.content});
  final String title;
  final String content;
}

class SettingGeneralLoadError extends SettingGeneralState {
  SettingGeneralLoadError({required this.title, required this.content});
  final String title;
  final String content;
}
