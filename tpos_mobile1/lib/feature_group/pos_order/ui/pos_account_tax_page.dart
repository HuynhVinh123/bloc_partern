import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_account_tax_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosAccountTaxPage extends StatefulWidget {
  @override
  _PosAccountTaxPageState createState() => _PosAccountTaxPageState();
}

class _PosAccountTaxPageState extends State<PosAccountTaxPage> {
  final _vm = locator<PosAccountTaxViewModel>();
  @override
  Widget build(BuildContext context) {
    return ViewBase<PosAccountTaxViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              /// Thuế mặc định
              title: Text(S.current.posOfSale_taxDefault),
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 3),
                        blurRadius: 3,
                        color: Colors.grey[400])
                  ]),
                  child: ListView.builder(
                      itemCount: _vm.accountTaxs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, _vm.accountTaxs[index]);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 2,
                                      color: Colors.grey[400])
                                ],
                                borderRadius: BorderRadius.circular(2)),
                            child: Text(
                              _vm.accountTaxs[index]?.name ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                )),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _vm.getAccountTax();
    const EmptyData();
  }
}
