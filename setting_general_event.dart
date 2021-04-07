import 'package:tdental_api_client/tdental_api_client.dart';

abstract class SettingGeneralEvent {}

class SettingGeneralInserted extends SettingGeneralEvent {
  SettingGeneralInserted(
      {required this.resConfigSetting,
      required this.titles,
      required this.checkCompanies,required this.amount});

  final ResConfigSetting resConfigSetting;
  final List<Map<String, dynamic>> titles;
  final List<Map<String, dynamic>> checkCompanies;
  final double amount;
}

class SettingGeneralLoaded extends SettingGeneralEvent {
  SettingGeneralLoaded({required this.titles, required this.checkCompanies});
  final List<Map<String, dynamic>> titles;
  final List<Map<String, dynamic>> checkCompanies;
}
