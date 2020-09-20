import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/user_report_staff/user_report_staff_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/user_report_staff/user_report_staff_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';


class UserReportStaffBloc extends Bloc<UserReportStaffEvent,UserReportStaffState>{
  UserReportStaffBloc({ReportSaleOrderApi reportSaleOrderApi}) : super(UserReportStaffLoading()){
    _apiClient = reportSaleOrderApi ?? GetIt.instance<ReportSaleOrderApi>();
  }

  ReportSaleOrderApi _apiClient;

  @override
  Stream<UserReportStaffState> mapEventToState(UserReportStaffEvent event) async*{
    yield UserReportStaffLoading();
    if (event is UserReportStaffLoaded) {
      yield* _getCompanyOfUser();
    }
  }

  Stream<UserReportStaffState> _getCompanyOfUser() async* {
    try {
      final List<UserReportStaffOrder> userReportStaffs =  await _apiClient.getUserReportStaff();
      yield UserReportStaffLoadSuccess(userReportStaffs: userReportStaffs);
    } catch (e, s) {
      yield UserReportStaffLoadFailure(title: "Thông báo",content: e.toString());
    }
  }


}