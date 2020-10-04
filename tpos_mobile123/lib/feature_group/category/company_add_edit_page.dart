import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/company_add_edit_viewmodel.dart';

import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class CompanyAddEditPage extends StatefulWidget {
  final Company company;
  CompanyAddEditPage({this.company});
  @override
  _CompanyAddEditPageState createState() => _CompanyAddEditPageState();
}

class _CompanyAddEditPageState extends State<CompanyAddEditPage> {
  var _vm = CompanyAddEditViewModel();
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
          actions: <Widget>[],
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
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: TextEditingController(text: _vm.company?.name),
                    decoration: InputDecoration(labelText: "Tên công ty (*)"),
                    onChanged: (text) => _vm.company?.name = text,
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: _vm.company?.moreInfo),
                    decoration:
                        InputDecoration(labelText: "Thông tin thêm (*)"),
                    onChanged: (text) => _vm.company?.moreInfo = text,
                  ),
                  TextField(
                    controller:
                        TextEditingController(text: _vm.company?.street),
                    decoration:
                        InputDecoration(labelText: "Số nhà, tên đường (*)"),
                    onChanged: (text) => _vm.company?.street = text,
                  ),
                  CheckboxListTile(
                    onChanged: (value) {
                      setState(() {
                        _vm.company.active = value;
                      });
                    },
                    title: Text("Cho phép hoạt động"),
                    value: _vm.company?.active ?? false,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
            width: double.infinity,
            padding: EdgeInsets.all(8),
            child: RaisedButton(
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              child: Text("LƯU"),
              onPressed: () {
                _vm.save(refreshOnSaved: true);
              },
            ))
      ],
    );
  }
}
