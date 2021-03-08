import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';

class UserReportStaffState {}

/// Loading trong khi đợi load dữ liệu
class UserReportStaffLoading extends UserReportStaffState {}

/// Trả về dữ liệu khi laod thành công
class UserReportStaffLoadSuccess extends UserReportStaffState {
  UserReportStaffLoadSuccess({this.userReportStaffs});
  final List<UserReportStaff> userReportStaffs;
}

/// Trả về lỗi khi load thất bại
class UserReportStaffLoadFailure extends UserReportStaffState {
  UserReportStaffLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
