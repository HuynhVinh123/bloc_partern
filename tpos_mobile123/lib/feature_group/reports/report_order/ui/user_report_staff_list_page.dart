import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/user_report_staff/user_report_staff_bloc.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/user_report_staff/user_report_staff_event.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/user_report_staff/user_report_staff_state.dart';

import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/user_report_staff.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class UserReportStaffListPage extends StatefulWidget {
  @override
  _UserReportStaffListPageState createState() =>
      _UserReportStaffListPageState();
}

class _UserReportStaffListPageState extends State<UserReportStaffListPage> {
  final _bloc = UserReportStaffBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(UserReportStaffLoaded());
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<UserReportStaffBloc>(
      bloc: _bloc,
      listen: (state) {
        if (state is UserReportStaffLoadFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      child: Scaffold(
          appBar: AppBar(
            /// Danh sách người bán
            title: Text(S.current.employees)
          ),
          body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocLoadingScreen<UserReportStaffBloc>(
        busyStates: const [UserReportStaffLoading],
        child: BlocBuilder<UserReportStaffBloc, UserReportStaffState>(
            builder: (context, state) => state is UserReportStaffLoadSuccess
                ? _buildListItem(state, context)
                : Container()));
  }

  Widget _buildListItem(
      UserReportStaffLoadSuccess state, BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) =>
            _buildItem(state.userReportStaffs[index], context),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: state.userReportStaffs.length);
  }

  Widget _buildItem(UserReportStaff item, BuildContext context) {
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
