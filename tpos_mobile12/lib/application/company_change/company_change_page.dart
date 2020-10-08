import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/application/application/application_bloc.dart';
import 'package:tpos_mobile/application/application/application_event.dart';
import 'package:tpos_mobile/application/company_change/company_change_bloc.dart';
import 'package:tpos_mobile/application/company_change/company_change_event.dart';
import 'package:tpos_mobile/application/company_change/company_change_state.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

class CompanyChangePage extends StatefulWidget {
  @override
  _CompanyChangePageState createState() => _CompanyChangePageState();
}

class _CompanyChangePageState extends State<CompanyChangePage> {
  final CompanyChangeBloc _bloc = CompanyChangeBloc();

  @override
  void initState() {
    _bloc.add(CompanyChangeLoaded());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<CompanyChangeBloc>(
      bloc: _bloc,
      busyStates: [CompanyChangeLoading],
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Đổi công ty"),
        ),
        body: BlocConsumer<CompanyChangeBloc, CompanyChangeState>(
          listener: (context, state) {
            if (state is CompanyChangeSuccess) {
              context.bloc<ApplicationBloc>().add(ApplicationRestarted());
            }
          },
          builder: (context, state) {
            if (state is CompanyChangeLoadSuccess) {
              if (state.companyGetResult.companies.isEmpty) {
                return const Center(
                  child: Text('Bạn đang có duy nhất 1 công ty/ chi nhánh '),
                );
              }
              return _buildList(state.companyGetResult);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildList(ChangeCurrentCompanyGetResult data) {
    return Scrollbar(
      child: ListView.separated(
        itemCount: data.companies.length,
        separatorBuilder: (context, index) => const Divider(
          height: 2,
        ),
        itemBuilder: (context, index) => _Item(
          company: data.companies[index],
          onTap: () {
            _bloc.add(CompanyChangeSelected(data.companies[index]));
          },
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({Key key, this.company, this.onTap}) : super(key: key);
  final ChangeCurrentCompanyGetResultCompany company;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(company.text),
      selected: company.selected,
      trailing: Icon(
        Icons.check_circle,
        color: company.selected ? Colors.green : Colors.grey.shade300,
      ),
      onTap: onTap,
    );
  }
}
