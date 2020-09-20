import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';

class UserReportStaffState {}

class UserReportStaffLoading extends UserReportStaffState {}

class UserReportStaffLoadSuccess extends UserReportStaffState {
  UserReportStaffLoadSuccess({this.userReportStaffs});
  final List<UserReportStaffOrder> userReportStaffs;
}

class UserReportStaffLoadFailure extends UserReportStaffState {
  UserReportStaffLoadFailure({this.title, this.content});
  final String title;
  final String content;
}