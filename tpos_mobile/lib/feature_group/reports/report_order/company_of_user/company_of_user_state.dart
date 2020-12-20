import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';

class CompanyOfUserState {}

/// Loading trong khi đợi load dữ liệu
class CompanyOfUserLoading extends CompanyOfUserState {}

/// Trả về dữ liệu khi laod thành công
class CompanyOfUserLoadSuccess extends CompanyOfUserState {
  CompanyOfUserLoadSuccess({this.companyUsers});
  final List<CompanyOfUser> companyUsers;
}

/// Trả về lỗi khi load thất bại
class CompanyOfUserLoadFailure extends CompanyOfUserState {
  CompanyOfUserLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
