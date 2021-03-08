import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/fast_sale_order/viewmodels/fast_create_invoice_with_default_product_viewmodel.dart';
import 'package:tpos_mobile/helpers/svg_icon.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SettingProductDefaultPage extends StatefulWidget {
  const SettingProductDefaultPage({this.vm});
  final FastCreateInvoiceWithDefaultProductViewModel vm;
  @override
  _SettingProductDefaultPageState createState() =>
      _SettingProductDefaultPageState();
}

class _SettingProductDefaultPageState extends State<SettingProductDefaultPage> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<FastCreateInvoiceWithDefaultProductViewModel>(
      model: widget.vm,
      child:
          ScopedModelDescendant<FastCreateInvoiceWithDefaultProductViewModel>(
              builder: (context, _, __) {
        return Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: '* ${S.current.settingDefaultProductYouNed}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      TextSpan(
                        text: S.current.settingDefaultProduct,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                      TextSpan(
                        text: S.current.settingDefaultProductToCreateOrder,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: !widget.vm.isShowProduct,
                  child: Shimmer.fromColors(
                    period: const Duration(milliseconds: 2000),
                    baseColor: Colors.white24,
                    highlightColor: Colors.grey,
                    enabled: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(6)),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white54,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Container(
                                width: double.infinity / 2,
                                height: 8.0,
                                color: Colors.white54)
                          ],
                        )),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.vm.isShowProduct,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                              color: Colors.white54,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[200])),
                          child: widget.vm.defaultProduct.imageUrl != null &&
                                  widget.vm.defaultProduct.imageUrl != ''
                              ? Image.network(
                                  widget.vm.defaultProduct.imageUrl ?? "",
                                )
                              : const SvgIcon(SvgIcon.emptyDataProduct)),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.vm.defaultProduct.name ?? ''),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            vietnameseCurrencyFormat(
                                widget.vm.defaultProduct.price ?? 0),
                            style: const TextStyle(color: Colors.red),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey)),
                    child: FlatButton(
                      child: Text(
                        widget.vm.isShowProduct
                            ? S.current.changeProduct
                            : S.current.selectProduct,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      onPressed: () {
                        _onSelectDefaultProduct();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  S.current.notifySettingDefaultProduct,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> _onSelectDefaultProduct() async {
    final Product product = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ProductSearchPage()));

    if (product != null) {
      widget.vm.defaultProduct = product;
    }
  }
}
