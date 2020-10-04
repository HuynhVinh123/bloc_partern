import 'package:tpos_api_client/tpos_api_client.dart';

abstract class CompanyChangeState {}

class CompanyChangeInitial extends CompanyChangeState {}

class CompanyChangeLoading extends CompanyChangeState {}

class CompanyChangeLoadSuccess extends CompanyChangeState {
  CompanyChangeLoadSuccess({this.companyGetResult});
  final ChangeCurrentCompanyGetResult companyGetResult;
}

class CompanyChangeLoadFailure extends CompanyChangeState {}

class CompanyChangeSuccess extends CompanyChangeState {}
