import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/my_widgets/number_input_field.dart';
import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/stock_change_product_quantity_viewmodel.dart';

import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';

class StockChangeProductQuantityPage extends StatefulWidget {
  final int productTemplateId;
  StockChangeProductQuantityPage({@required this.productTemplateId});
  @override
  _StockChangeProductQuantityPageState createState() =>
      _StockChangeProductQuantityPageState();
}

class _StockChangeProductQuantityPageState
    extends State<StockChangeProductQuantityPage> {
  var _vm = StockChangeProductQuantityViewModel();
  @override
  void initState() {
    _vm.init(productTemplateId: widget.productTemplateId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UIViewModelBase<StockChangeProductQuantityViewModel>(
      viewModel: _vm,
      closeKeyboardOnTap: true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thay đổi số lượng kho sản phẩm"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                _vm.save().then((value) {
                  if (value) Navigator.pop(context);
                });
              },
            )
          ],
        ),
        body: _buildBody(),
        bottomNavigationBar: Container(
          width: double.infinity,
          padding: EdgeInsets.all(8),
          child: RaisedButton(
            textColor: Colors.white,
            child: Text("ÁP DỤNG & ĐÓNG"),
            onPressed: () {
              _vm.save().then((value) {
                if (value) Navigator.pop(context);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: ScopedModelDescendant<StockChangeProductQuantityViewModel>(
        builder: (context, child, model) => Column(
          children: <Widget>[
            // Sản phẩm
            _RowContainer(
              title: Text("Sản phẩm: "),
              value: DropdownButton<Product>(
                items: _vm.products
                    ?.map(
                      (f) => DropdownMenuItem<Product>(
                        value: f,
                        child: Text(f.nameGet),
                      ),
                    )
                    ?.toList(),
                value: _vm.selectedProduct,
                onChanged: (value) {
                  _vm.setProduct(value);
                },
                isExpanded: true,
              ),
            ),
            _RowContainer(
              title: Text("Địa điểm: "),
              value: DropdownButton<StockLocation>(
                items: _vm.stockLocations
                    ?.map((f) => DropdownMenuItem<StockLocation>(
                          value: f,
                          child: Text(f.nameGet),
                        ))
                    ?.toList(),
                value: _vm.selectedLocation,
                onChanged: (value) {
                  _vm.setStockLocation(value);
                },
                isExpanded: true,
              ),
            ),
            _RowContainer(
              title: Text("SL thực tế: "),
              value: AppInputNumberField(
                decoration: InputDecoration(),
                value: _vm.model?.newQuantity,
                locate: "vi_VN",
                onValueChanged: (value) {
                  _vm.model?.newQuantity = value;
                },
              ),
            ),

            // Địa điểm
          ],
        ),
      ),
    );
  }
}

class _RowContainer extends StatelessWidget {
  final Widget title;
  final Widget value;
  _RowContainer({this.title, this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 100,
            child: title,
          ),
          Expanded(
            child: value,
          ),
        ],
      ),
    );
  }
}
