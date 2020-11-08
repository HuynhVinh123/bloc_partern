import 'package:tpos_api_client/tpos_api_client.dart';

abstract class CompanyChangeEvent {}

class CompanyChangeLoaded extends CompanyChangeEvent {}

class CompanyChangeSelected extends CompanyChangeEvent {
  CompanyChangeSelected(this.item);
  final ChangeCurrentCompanyGetResultCompany item;
}
