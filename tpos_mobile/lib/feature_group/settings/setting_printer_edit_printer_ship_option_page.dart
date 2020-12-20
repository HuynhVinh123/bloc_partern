/*
 * *
 *  * Created by Nam, Công ty TNHH TM& DV Trực Tuyến Trường Minh Thịnh on 7/5/19 4:54 PM
 *  * Copyright (c) 2019 . All rights reserved.
 *  * Last modified 7/5/19 3:18 PM
 *
 */

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/feature_group/sale_online/viewmodels/setting_printship_viewmodel.dart';
import 'package:tpos_mobile/feature_group/settings/setting_printer_list.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile/models/enums/font_scale.dart';
import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';

import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/src/tpos_apis/models/printer_config_other.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_models.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingPrinterEditPrinterShipOptionPage extends StatefulWidget {
  @override
  _SettingPrinterEditPrinterShipOptionPageState createState() =>
      _SettingPrinterEditPrinterShipOptionPageState();
}

class _SettingPrinterEditPrinterShipOptionPageState
    extends State<SettingPrinterEditPrinterShipOptionPage> {
  final _vm = SettingPrintShipViewModel();
  var dividerMin = const Divider(
    height: 2,
  );

  var sizedBoxMin = const SizedBox(
    height: 10,
  );

  var shipPrintProfile = supportPrinterProfiles["ship"];

  @override
  void initState() {
    _vm.initCommand();
    super.initState();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SettingPrintShipViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.setting_printerConfigureShip),
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
    final decorate = BoxDecoration(
        borderRadius: BorderRadius.circular(10), color: Colors.white);

    const headerStyle =
        TextStyle(color: Colors.blue, fontWeight: FontWeight.bold);
    return Column(
      children: <Widget>[
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: ScopedModelDescendant<SettingPrintShipViewModel>(
              builder: (context, child, model) {
                return Column(
                  children: <Widget>[
                    // Máy in
                    Container(
                      decoration: decorate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Text(
                              S.current.printer.toUpperCase(),
                              style: headerStyle,
                            ),
                          ),
                          dividerMin,
                          ListTile(
                            title: Text(
                              _vm.selectedPrintName ?? "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                                "${_vm.selectedPrintDevice?.ip} | ${_vm.selectedPrintDevice?.port}"),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () async {
                              final PrinterDevice selectedPrinter =
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
                    // Mẫu in
                    if (_vm.selectedPrintDevice?.type != "preview") ...[
                      sizedBoxMin,
                      Container(
                        decoration: decorate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // "MẪU IN"
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Text(
                                S.current.setting_printerSaleOnlinePrintedForm,
                                style: headerStyle,
                              ),
                            ),
                            dividerMin,
                            Builder(
                              builder: (context) {
                                if (_vm.selectedPrintDevice?.type ==
                                    "tpos_printer") {
                                  return ListTile(
                                    //Với tùy chọn này vui lòng điều chỉnh mẫu in trên phần mềm TPOS PRINTER cài trên PC/ Laptop
                                    subtitle: Text(
                                      S.current.setting_printerShipSupport,
                                      style:
                                          const TextStyle(color: Colors.orange),
                                    ),
                                  );
                                }
                                return ListTile(
                                  subtitle: DropdownButton<String>(
                                    underline: const SizedBox(),
                                    isExpanded: true,
                                    //họn mẫu in
                                    hint: Text(S.current
                                        .setting_printerShipSelectTemplate),
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
                        _vm.setting.shipSize == 'BILL80-IMAGE') ...[
                      sizedBoxMin,
                      Container(
                        decoration: decorate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //TỈ LỆ FONT CHỮ
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Text(
                                S.current.setting_printerShipFontRatio
                                    .toUpperCase(),
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
                                    _vm.setting.shipFontScale = value;
                                  });
                                },
                                value: _vm.setting.shipFontScale,
                              ),
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                    sizedBoxMin,
                    // Cấu hình nâng cao mẫu in
                    Container(
                      decoration: decorate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //NÂNG CAO
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Text(
                              S.current.setting_printerSaleOnlineAd
                                  .toUpperCase(),
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
                    sizedBoxMin,
                    Container(
                      decoration: decorate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // /"KHÁC"
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 8, bottom: 8),
                            child: Text(
                              S.current.other.toUpperCase(),
                              style: headerStyle,
                            ),
                          ),
                          dividerMin,
                          //Hiện tiền cọc
                          CheckboxListTile(
                            value:
                                _vm.setting.settingPrintShipShowDepositAmount,
                            title:
                                Text(S.current.setting_printerShipShowDeposit),
                            onChanged: (value) {
                              setState(() {
                                _vm.setting.settingPrintShipShowDepositAmount =
                                    value;
                              });
                            },
                          ),
                          // /Hiện số lượng sản phẩm
                          CheckboxListTile(
                            value:
                                _vm.setting.settingPrintShipShowProductQuantity,
                            title: Text(S.current
                                .setting_printerShipShowNumberOfProduct),
                            onChanged: (value) {
                              setState(() {
                                _vm.setting
                                        .settingPrintShipShowProductQuantity =
                                    value;
                              });
                            },
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
          padding: const EdgeInsets.only(left: 8, right: 8, top: 0, bottom: 0),
          child: RaisedButton(
            textColor: Colors.white,
            onPressed: () async {
              _vm.saveCommand().then((value) {
                if (value) Navigator.pop(context);
              });
            },
            child: Text(
                "${S.current.save.toUpperCase()} & ${S.current.close.toUpperCase()}"),
          ),
        ),
      ],
    );
  }
}

class SettingPrintWebConfig extends StatefulWidget {
  const SettingPrintWebConfig(
      {this.config, this.hideSelectTemplate = false, this.hideNote = false});
  final PrinterConfig config;
  final bool hideSelectTemplate;
  final bool hideNote;

  @override
  _SettingPrintWebConfigState createState() => _SettingPrintWebConfigState();
}

class _SettingPrintWebConfigState extends State<SettingPrintWebConfig> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.config == null) {
      return const SizedBox();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!widget.hideSelectTemplate) ...[
            //Mẫu in
            Text(S.current.setting_printerSaleOnlinePrintedForm),
            const Divider(),
            DropdownButton<String>(
              isExpanded: true,
              value: widget.config.template,
              onChanged: (value) {
                setState(() {
                  widget.config.template = value;
                });
              },
              items: const [
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
          ],
          TextField(
            controller: TextEditingController(text: widget.config.note),
            readOnly: true,
            maxLines: null,
            onTap: () async {
              final content =
                  await showTextInputDialog(context, widget.config.note);
              if (content != null) {
                setState(() {
                  widget.config.note = content;
                });
              }
            },
            // Ghi chú trên phiếu
            decoration: InputDecoration(
              labelText: S.current.setting_printerShipNote,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          _buildOther(widget.config.others),
        ],
      ),
    );
  }

  Widget _buildOther(List<PrinterConfigOther> items) {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
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
        separatorBuilder: (context, index) => const Divider(
              height: 2,
            ),
        itemCount: items?.length ?? 0);
  }
}
