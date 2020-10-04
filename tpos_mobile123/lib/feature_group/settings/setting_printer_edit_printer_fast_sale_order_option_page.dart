/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 3:18 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/setting_print_fastsaleorder_viewmodel.dart';
import 'package:tpos_mobile/feature_group/settings/setting_printer_edit_printer_ship_option_page.dart';
import 'package:tpos_mobile/feature_group/settings/setting_printer_list.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';

import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';

class SettingPrinterEditPrinterFastSaleOrderOptionPage extends StatefulWidget {
  @override
  _SettingPrinterEditPrinterFastSaleOrderOptionPageState createState() =>
      _SettingPrinterEditPrinterFastSaleOrderOptionPageState();
}

class _SettingPrinterEditPrinterFastSaleOrderOptionPageState
    extends State<SettingPrinterEditPrinterFastSaleOrderOptionPage> {
  var _vm = SettingPrintFastSaleOrderViewModel();
  var dividerMin = new Divider(
    height: 2,
  );

  var sizedBoxMin = new SizedBox(
    height: 10,
  );

  var shipPrintProfile = supportPrinterProfiles["fast_sale_order"];

  @override
  void initState() {
    _vm.initCommand();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SettingPrintFastSaleOrderViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cấu hình máy in hóa đơn"),
        ),
        body: UIViewModelBase(
          viewModel: _vm,
          child: _buildBody(),
        ),
        backgroundColor: Colors.grey.shade200,
      ),
    );
  }

  Widget _buildBody() {
    var decorate = BoxDecoration(
        borderRadius: BorderRadius.circular(8), color: Colors.white);

    var headerStyle =
        new TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: ScopedModelDescendant<SettingPrintFastSaleOrderViewModel>(
              builder: (context, child, model) {
                return Column(
                  children: <Widget>[
                    Container(
                      decoration: decorate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Text(
                              "MÁY IN",
                              style: headerStyle,
                            ),
                          ),
                          dividerMin,
                          ListTile(
                            title: Text(
                              "${_vm.selectedPrintName}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "${_vm.selectedPrintDevice?.ip} | ${_vm.selectedPrintDevice?.port}"),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () async {
                              PrinterDevice selectedPrinter =
                                  await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingPrinterListPage(
                                    selectedPrinterName: _vm.selectedPrintName,
                                    isSelectPage: true,
                                  ),
                                ),
                              );

                              if (selectedPrinter != null) {
                                _vm.setPrinterCommand(selectedPrinter);
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    if (_vm.selectedPrintDevice?.type != "preview") ...[
                      sizedBoxMin,
                      Container(
                        decoration: decorate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Text(
                                "MẪU IN",
                                style: headerStyle,
                              ),
                            ),
                            dividerMin,
                            Builder(
                              builder: (context) {
                                if (_vm.selectedPrintDevice?.type ==
                                    "tpos_printer") {
                                  return ListTile(
                                    subtitle: Text(
                                      "Hỗ trợ mẫu in 80mm",
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  );
                                }
                                return ListTile(
                                  subtitle: DropdownButton<String>(
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    hint: Text("Chọn mẫu in"),
                                    value: _vm.customTemplate,
                                    items: _vm.supportTemplates
                                        ?.map(
                                          (f) => DropdownMenuItem<String>(
                                            child: Text(f.name),
                                            value: f.code,
                                          ),
                                        )
                                        ?.toList(),
                                    onChanged: (value) {
                                      _vm.setPrinterTemplateCommand(value);
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Tỉ lệ font chữ
                    if (_vm.selectedPrintDevice?.type == 'esc_pos' &&
                        _vm.customTemplate == 'BILL80-IMAGE') ...[
                      sizedBoxMin,
                      Container(
                        decoration: decorate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Text(
                                "TỈ LỆ FONT CHỮ",
                                style: headerStyle,
                              ),
                            ),
                            Container(
                              child: DropdownButton<FontScale>(
                                items: FontScale.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.getDescription(),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                isExpanded: true,
                                onChanged: (value) {
                                  setState(() {
                                    _vm.setFontScale(value);
                                  });
                                },
                                value: _vm.fontScale,
                              ),
                              padding: EdgeInsets.only(left: 16, right: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                    sizedBoxMin,
                    Container(
                      decoration: decorate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Text(
                              "NÂNG CAO",
                              style: headerStyle,
                            ),
                          ),
                          dividerMin,
                          SettingPrintWebConfig(
                            config: _vm.webPrinterConfig,
                            hideSelectTemplate: _vm.selectedPrintDevice?.type ==
                                    "tpos_printer" ||
                                _vm.selectedPrintDevice?.type == "esc_pos",
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.grey.shade300,
          padding: EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: RaisedButton(
            textColor: Colors.white,
            onPressed: () async {
              _vm.saveCommand().then((value) {
                if (value) Navigator.pop(context);
              });
            },
            child: Text("LƯU & ĐÓNG"),
          ),
        ),
      ],
    );
  }
}
