import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

import '../../../../locator.dart';
import 'company_of_user_event.dart';
import 'company_of_user_state.dart';

class CompanyOfUserBloc extends Bloc<CompanyOfUserEvent, CompanyOfUserState> {
  CompanyOfUserBloc({ITposApiService tposApi}) : super(CompanyOfUserLoading()) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }

  ITposApiService _tposApi;

  @override
  Stream<CompanyOfUserState> mapEventToState(CompanyOfUserEvent event) async* {
    yield CompanyOfUserLoading();
    if (event is CompanyOfUserLoaded) {
      yield* _getCompanyOfUser();
    }
  }

  Stream<CompanyOfUserState> _getCompanyOfUser() async* {
    try {
      final List<CompanyOfUser> companyUsers =
          await _tposApi.getCompanyOfUser();
      yield CompanyOfUserLoadSuccess(companyUsers: companyUsers);
    } catch (e) {
      yield CompanyOfUserLoadFailure(title: "Thông báo", content: e.toString());
    }
  }
}
