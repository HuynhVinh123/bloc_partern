import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_vm_base.dart';
import 'package:tpos_mobile/feature_group/settings/setting_printer_list.dart';
import 'package:tpos_mobile/feature_group/settings/viewmodels/setting_printer_pos_order_viewmodel.dart';

import 'package:tpos_mobile/services/app_setting_service.dart';
import 'package:tpos_mobile/services/print_service/printer_device.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingPrinterPosOrderPage extends StatefulWidget {
  @override
  _SettingPrinterPosOrderPageState createState() =>
      _SettingPrinterPosOrderPageState();
}

class _SettingPrinterPosOrderPageState
    extends State<SettingPrinterPosOrderPage> {
  final _vm = SettingPrinterPosOrderViewModel();
  var dividerMin = const Divider(
    height: 2,
  );

  var sizedBoxMin = const SizedBox(
    height: 10,
  );

  var shipPrintProfile = supportPrinterProfiles["pos_order"];

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
    return ScopedModel<SettingPrinterPosOrderViewModel>(
      model: _vm,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.current.setting_printerPointOfSale),
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
            child: ScopedModelDescendant<SettingPrinterPosOrderViewModel>(
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
                            // /"MÁY IN
                            child: Text(
                              S.current.print.toUpperCase(),
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
                    if (_vm.selectedPrintDevice?.type != "preview") ...[
                      sizedBoxMin,
                      Container(
                        decoration: decorate,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //"MẪU IN"
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, top: 8, bottom: 8),
                              child: Text(
                                S.current.setting_printerSaleOnlinePrintedForm
                                    .toUpperCase(),
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
                                      S.current.setting_printerShipSupport,
                                      style:
                                          const TextStyle(color: Colors.orange),
                                    ),
                                  );
                                }
                                // /Chọn mẫu in
                                return ListTile(
                                  subtitle: DropdownButton<String>(
                                    underline: const SizedBox(),
                                    isExpanded: true,
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
                    sizedBoxMin,
                    Container(color: Colors.white, child: _buildOther())
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

  Widget _buildOther() {
    return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(_vm.webPrinterConfig.others[index].text ?? ""),
            value: _vm.webPrinterConfig.others[index].value,
            onChanged: (value) {
              setState(() {
                if (_vm.webPrinterConfig.others[index].key ==
                    'config.hide_company_address') {
                  _vm.isShowCompanyAddress = value;
                } else if (_vm.webPrinterConfig.others[index].key ==
                    'config.hide_company_email') {
                  _vm.isShowCompanyEmail = value;
                } else if (_vm.webPrinterConfig.others[index].key ==
                    'config.hide_company_phone_number') {
                  _vm.isShowCompanyPhoneNumber = value;
                }
                _vm.webPrinterConfig.others[index].value = value;
              });
            },
          );
        },
        separatorBuilder: (context, index) => const Divider(
              height: 2,
            ),
        itemCount: _vm.webPrinterConfig?.others?.length ?? 0);
  }
}
