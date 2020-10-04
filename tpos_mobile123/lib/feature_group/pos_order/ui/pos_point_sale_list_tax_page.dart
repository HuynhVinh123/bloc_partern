import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/point_sale.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_point_sale_list_tax_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class PosPointSaleListTaxPage extends StatefulWidget {
  @override
  _PosPointSaleListTaxPageState createState() =>
      _PosPointSaleListTaxPageState();
}

class _PosPointSaleListTaxPageState extends State<PosPointSaleListTaxPage> {
  final _vm = locator<PosPointSaleListTaxViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPointSaleListTaxViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Thuế"),
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
                      itemCount: _vm.pointSaleTaxs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            if (_vm.pointSaleTaxs[index].id == null) {
                              Navigator.pop(context, null);
                            } else {
                              Navigator.pop(context, _vm.pointSaleTaxs[index]);
                            }
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
                              _vm.pointSaleTaxs[index]?.name ?? "",
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
    getPointSaleTax();
  }

  Future<void> getPointSaleTax() async {
    _vm.pointSaleTaxs.add(Tax(name: "Không chọn thuế"));
    await _vm.getPointSaleTaxs();
  }
}
