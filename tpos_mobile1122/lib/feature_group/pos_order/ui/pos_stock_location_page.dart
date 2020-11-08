import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_stock_location_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosStockLocationPage extends StatefulWidget {
  @override
  _PosStockLocationPageState createState() => _PosStockLocationPageState();
}

class _PosStockLocationPageState extends State<PosStockLocationPage> {
  final _vm = locator<PosStockLocationViewModel>();

  @override
  void initState() {
    super.initState();
    _vm.getStockLocation();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosStockLocationViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              /// Địa điểm kho
              title: Text(S.current.posOfSale_stockLocation),
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
                      itemCount: _vm.stockLocations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, _vm.stockLocations[index]);
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
                              _vm.stockLocations[index]?.nameGet ?? "",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }),
                )),
          );
        });
  }
}
