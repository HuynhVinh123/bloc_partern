import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/company_add_edit_viewmodel.dart';

class CompanyAddEditPage extends StatefulWidget {
  const CompanyAddEditPage({this.company});
  final Company company;

  @override
  _CompanyAddEditPageState createState() => _CompanyAddEditPageState();
}

class _CompanyAddEditPageState extends State<CompanyAddEditPage> {
  final _vm = CompanyAddEditViewModel();
  @override
  void initState() {
    _vm.init(company: widget.company);
    _vm.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase(
      viewModel: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              "${_vm.company != null && _vm.company.id != null ? "Sửa công ty" : "Thêm công ty mới"}"),
          actions: const <Widget>[],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ScopedModelDescendant<CompanyAddEditViewModel>(
            builder: (context, _, __) => SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: TextEditingController(text: _vm.company?.name),
                    decoration:
                        const InputDecoration(labelText: "Tên công ty (*)"),
                    onChanged: (text) => _vm.company?.name = text,
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: _vm.company?.moreInfo),
                    decoration:
                        const InputDecoration(labelText: "Thông tin thêm (*)"),
                    onChanged: (text) => _vm.company?.moreInfo = text,
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: _vm.company?.street),
                    decoration: const InputDecoration(
                        labelText: "Số nhà, tên đường (*)"),
                    onChanged: (text) => _vm.company?.street = text,
                  ),
                  CheckboxListTile(
                    onChanged: (value) {
                      setState(() {
                        _vm.company.active = value;
                      });
                    },
                    title: const Text("Cho phép hoạt động"),
                    value: _vm.company?.active ?? false,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            child: RaisedButton(
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: const Text("LƯU"),
              onPressed: () {
                _vm.save(refreshOnSaved: true);
              },
            ))
      ],
    );
  }
}
