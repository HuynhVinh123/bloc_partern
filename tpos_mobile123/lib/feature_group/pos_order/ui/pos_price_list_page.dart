import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_price_list_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class PosPriceListPage extends StatefulWidget {
  const PosPriceListPage(this.isPointSale);
  final bool isPointSale;
  @override
  _PosPriceListPageState createState() => _PosPriceListPageState();
}

class _PosPriceListPageState extends State<PosPriceListPage> {
  final _vm = locator<PosPriceListViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPriceListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Bảng giá mặc định"),
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
                      itemCount: _vm.priceLists.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, _vm.priceLists[index]);
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
                              _vm.priceLists[index]?.name ?? "",
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
    if (widget.isPointSale) {
      _vm.getPriceListPointSale();
    } else {
      _vm.getPriceLists();
    }
  }
}
