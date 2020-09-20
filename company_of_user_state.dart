import 'package:tpos_api_client/tpos_api_client.dart';

class CompanyOfUserState {}

class CompanyOfUserLoading extends CompanyOfUserState {}

class CompanyOfUserLoadSuccess extends CompanyOfUserState {
  CompanyOfUserLoadSuccess({this.companyUsers});
  final List<UserCompany> companyUsers;
}

class CompanyOfUserLoadFailure extends CompanyOfUserState {
  CompanyOfUserLoadFailure({this.title, this.content});
  final String title;
  final String content;
}