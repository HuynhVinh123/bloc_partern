import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/setting_company_printer_viewmodel.dart';

import 'package:tpos_mobile/src/tpos_apis/models/printer_config_other.dart';
import 'package:tpos_mobile/src/tpos_apis/models/printer_configs.dart';

class SettingCompanyPrinterPage extends StatefulWidget {
  @override
  _SettingCompanyPrinterPageState createState() =>
      _SettingCompanyPrinterPageState();
}

class _SettingCompanyPrinterPageState extends State<SettingCompanyPrinterPage> {
  var _vm = SettingCompanyPrinterViewModel();

  @override
  void initState() {
    _vm.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SettingCompanyPrinterViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cấu hình máy in"),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<SettingCompanyPrinterViewModel>(
      builder: (context, child, model) {
        return ListView.separated(
            itemBuilder: (context, index) {
              return _buildItem(_vm.supportPrinterConfig[index]);
            },
            separatorBuilder: (context, index) => Divider(
                  height: 2,
                ),
            itemCount: _vm.supportPrinterConfig?.length ?? 0);
      },
    );
  }

  Widget _buildItem(PrinterConfig item) {
    return ListTile(
      leading: Icon(Icons.print),
      title: Text(item.name),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SettingCompanyPrinterDetail(item),
          ),
        );

        _vm.save();
      },
    );
  }
}

class SettingCompanyPrinterDetail extends StatefulWidget {
  final PrinterConfig printConfig;
  SettingCompanyPrinterDetail(this.printConfig);

  @override
  _SettingCompanyPrinterDetailState createState() =>
      _SettingCompanyPrinterDetailState();
}

class _SettingCompanyPrinterDetailState
    extends State<SettingCompanyPrinterDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.printConfig.name),
        actions: <Widget>[
          IconButton(
            icon: (Icon(Icons.save)),
            onPressed: () {
              Navigator.pop(context, true);
            },
          )
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Mẫu in "),
          Divider(),
          DropdownButton<String>(
            isExpanded: true,
            value: widget.printConfig.template,
            onChanged: (value) {
              setState(() {
                widget.printConfig.template = value;
              });
            },
            items: [
              DropdownMenuItem<String>(
                child: Text("BILL58"),
                value: "BILL58",
              ),
              DropdownMenuItem<String>(
                child: Text("BILL80"),
                value: "BILL80",
              ),
              DropdownMenuItem<String>(
                child: Text("A5"),
                value: "A5",
              ),
              DropdownMenuItem<String>(
                child: Text("A4"),
                value: "A4",
              ),
            ],
          ),
          TextField(
            controller: TextEditingController(text: widget.printConfig.note),
            onChanged: (text) {
              widget.printConfig.note = text;
            },
            decoration: InputDecoration(
              labelText: "Ghi chú trên phiếu",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          _buildOther(widget.printConfig.others),
        ],
      ),
    );
  }

  Widget _buildOther(List<PrinterConfigOther> items) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(items[index].text),
            value: items[index].value,
            onChanged: (value) {
              setState(() {
                items[index].value = value;
              });
            },
          );
        },
        separatorBuilder: (context, index) => Divider(
              height: 2,
            ),
        itemCount: items?.length ?? 0);
  }
}
