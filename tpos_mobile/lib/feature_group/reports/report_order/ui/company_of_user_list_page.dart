import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/company_of_user/company_of_user_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/company_of_user/company_of_user_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/company_of_user/company_of_user_state.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/empty_data_page.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class CompanyOfUserListPage extends StatefulWidget {
  @override
  _CompanyOfUserListPageState createState() => _CompanyOfUserListPageState();
}

class _CompanyOfUserListPageState extends State<CompanyOfUserListPage> {
  final _bloc = CompanyOfUserBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(CompanyOfUserLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<CompanyOfUserBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is CompanyOfUserLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            /// Danh sách công ty
            title: Text(S.current.companies),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    return BlocLoadingScreen<CompanyOfUserBloc>(
        busyStates: const [CompanyOfUserLoading],
        child: BlocBuilder<CompanyOfUserBloc, CompanyOfUserState>(
            builder: (context, state) => state is CompanyOfUserLoadSuccess
                ? _buildListItem(state)
                : Container()));
  }

  Widget _buildListItem(CompanyOfUserLoadSuccess state) {
    return state.companyUsers.isEmpty
        ? EmptyDataPage()
        : ListView.separated(
            itemBuilder: (context, index) =>
                _buildItem(state.companyUsers[index]),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: state.companyUsers.length);
  }

  Widget _buildItem(CompanyOfUser item) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, item);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(item.text ?? ""),
      ),
    );
  }
}
