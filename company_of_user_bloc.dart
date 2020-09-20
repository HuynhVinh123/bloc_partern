import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

import 'package:tpos_mobile/feature_group/sale_online/blocs/company_of_user/company_of_user_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/company_of_user/company_of_user_state.dart';

class CompanyOfUserBloc extends Bloc<CompanyOfUserEvent,CompanyOfUserState>{
  CompanyOfUserBloc({ReportSaleOrderApi reportSaleOrderApi}) : super(CompanyOfUserLoading()){
    _apiClient = reportSaleOrderApi ?? GetIt.instance<ReportSaleOrderApi>();
  }

  ReportSaleOrderApi _apiClient;

  @override
  Stream<CompanyOfUserState> mapEventToState(CompanyOfUserEvent event) async*{
    yield CompanyOfUserLoading();
    if (event is CompanyOfUserLoaded) {
      yield* _getCompanyOfUser();
    }
  }

  Stream<CompanyOfUserState> _getCompanyOfUser() async* {
    try {
      final List<UserCompany> companyUsers =  await _apiClient.getCompanyOffUserReportOrder();
      yield CompanyOfUserLoadSuccess(companyUsers: companyUsers);
    } catch (e, s) {
      yield CompanyOfUserLoadFailure(title: "Thông báo",content: e.toString());
    }
  }


}