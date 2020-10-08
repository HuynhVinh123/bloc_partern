import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/user_report_staff/user_report_staff_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/user_report_staff/user_report_staff_state.dart';

import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

import '../../../../locator.dart';

class UserReportStaffBloc
    extends Bloc<UserReportStaffEvent, UserReportStaffState> {
  UserReportStaffBloc({ITposApiService tposApi})
      : super(UserReportStaffLoading()) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }

  ITposApiService _tposApi;

  @override
  Stream<UserReportStaffState> mapEventToState(
      UserReportStaffEvent event) async* {
    yield UserReportStaffLoading();
    if (event is UserReportStaffLoaded) {
      yield* _getCompanyOfUser();
    }
  }

  Stream<UserReportStaffState> _getCompanyOfUser() async* {
    try {
      final List<UserReportStaff> userReportStaffs =
          await _tposApi.getUserReportStaff();
      yield UserReportStaffLoadSuccess(userReportStaffs: userReportStaffs);
    } catch (e, s) {
      yield UserReportStaffLoadFailure(
          title: "Thông báo", content: e.toString());
    }
  }
}
