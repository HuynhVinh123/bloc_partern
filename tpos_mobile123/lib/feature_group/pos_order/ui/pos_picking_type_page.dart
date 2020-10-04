import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/pos_order/viewmodels/pos_picking_type_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class PosPickingTypePage extends StatefulWidget {
  @override
  _PosPickingTypePageState createState() => _PosPickingTypePageState();
}

class _PosPickingTypePageState extends State<PosPickingTypePage> {
  final _vm = locator<PosPickingTypeViewModel>();

  @override
  Widget build(BuildContext context) {
    return ViewBase<PosPickingTypeViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Loại hoạt dộng"),
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
                      itemCount: _vm.pickingTypes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context, _vm.pickingTypes[index]);
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
                              _vm.pickingTypes[index]?.nameGet ?? "",
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
    _vm.getPickingTypes();
  }
}
