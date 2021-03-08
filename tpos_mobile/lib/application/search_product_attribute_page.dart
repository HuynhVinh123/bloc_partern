import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/application/viewmodel/search_product_attribute_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';

class SearchProductAttributePage extends StatefulWidget {
  const SearchProductAttributePage(this.nameApi, {this.nameAttribute});
  final String nameApi;
  final String nameAttribute;

  @override
  _SearchProductAttributePageState createState() =>
      _SearchProductAttributePageState();
}

class _SearchProductAttributePageState
    extends State<SearchProductAttributePage> {
  final _vm = locator<SearchProductAttributeViewModel>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    if (widget.nameApi == "productAttribute") {
      await _vm.getProductAttributes();
    } else {
      await _vm.getProductAttributeValues();
      if (widget.nameAttribute != null) {
        _vm.filterProductAttributeValues(widget.nameAttribute);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<SearchProductAttributeViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Tìm kiếm"),
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
                      itemCount: _vm.productAttributes == null
                          ? 0
                          : _vm.productAttributes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(
                                context, _vm.productAttributes[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 12),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 1),
                                        blurRadius: 1,
                                        color: Colors.grey[300])
                                  ],
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text(
                                widget.nameApi == "productAttribute"
                                    ? "${_vm.productAttributes[index].name ?? ""}"
                                    : "${_vm.productAttributes[index].nameGet ?? ""}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        );
                      }),
                )),
          );
        });
  }
}
