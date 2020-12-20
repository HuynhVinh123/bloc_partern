import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/attribute_value_price_bloc.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/attribute_value_price_event.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/bloc/attribute_value_price_state.dart';
import 'package:tpos_mobile/feature_group/category/attribute_value_price/ui/attribute_value_price_add_edit_page.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_snack_bar.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class AttributeValuePricePage extends StatefulWidget {
  const AttributeValuePricePage({Key key, this.productTemplate}) : super(key: key);

  @override
  _AttributeValuePricePageState createState() => _AttributeValuePricePageState();
  final ProductTemplate productTemplate;
}

class _AttributeValuePricePageState extends State<AttributeValuePricePage> {
  AttributeValuePriceBloc _attributeValuePriceBloc;
  List<ProductAttributeValue> _productAttributeValues;
  bool _change = false;

  @override
  void initState() {
    _attributeValuePriceBloc = AttributeValuePriceBloc();
    _attributeValuePriceBloc.add(AttributeValuePriceInitial(productTemplate: widget.productTemplate));
    super.initState();
  }

  @override
  void dispose() {
    _attributeValuePriceBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_change);
        return false;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).attributePrice,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(_change);
          }),
      actions: [
        IconButton(
            iconSize: 30,
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () async {
              final ProductAttributeValue result = await Navigator.push<ProductAttributeValue>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AttributeValuePriceDetailsAddEditPage(productTemplateId: widget.productTemplate.id),
                ),
              );

              if (result != null) {
                _attributeValuePriceBloc.add(AttributeValuePriceInitial(productTemplate: widget.productTemplate));
              }
            })
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<AttributeValuePriceBloc, AttributeValuePriceState>(
      loadingState: AttributeValuePriceLoading,
      busyState: AttributeValuePriceBusy,
      bloc: _attributeValuePriceBloc,
      errorState: AttributeValuePriceLoadFailure,
      errorBuilder: (BuildContext context, AttributeValuePriceState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is AttributeValuePriceLoadFailure) {
          error = state.error ?? S.of(context).canNotGetDataFromServer;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.of(context).loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: AppButton(
                  onPressed: () {
                    _attributeValuePriceBloc.add(AttributeValuePriceInitial(productTemplate: widget.productTemplate));
                  },
                  width: 180,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 40, 167, 69),
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.sync,
                          color: Colors.white,
                          size: 23,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          S.of(context).refreshPage,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (BuildContext context, AttributeValuePriceState state) {
        if (state is AttributeValuePriceDeleteFailure) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is AttributeValuePriceDeleteSuccess) {
          _change = true;
          final Widget snackBar =
              customSnackBar(message: S.of(context).successfullyParam(S.of(context).delete), context: context);
          Scaffold.of(context).showSnackBar(snackBar);
        }
      },
      builder: (BuildContext context, AttributeValuePriceState state) {
        if (state is AttributeValuePriceLoadSuccess) {
          _productAttributeValues = state.productAttributeValues;
        }

        return _productAttributeValues.isEmpty ? _buildEmptyList() : _buildList();
      },
    );
  }

  Widget _buildList() {
    double maxWidth = 0;

    for (final ProductAttributeValue productAttributeValue in _productAttributeValues) {
      final double textWidth = getTextLength(
          '+ ${productAttributeValue.priceExtra != null ? vietnameseCurrencyFormat(productAttributeValue.priceExtra) : '0'} đ',
          const TextStyle(color: Color(0xff929DAA), fontSize: 14));
      maxWidth = maxWidth < textWidth ? textWidth : maxWidth;
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0, top: 16),
      child: ListView.separated(
        itemCount: _productAttributeValues.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 0);
        },
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(_productAttributeValues[index], maxWidth);
        },
      ),
    );
  }

  ///Xây dựng giao diện trống
  Widget _buildEmptyList() {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget.empty(
          statusName: S.of(context).noData,
          content: S.of(context).emptyNotificationParam(S.of(context).attributePrice.toLowerCase()),
          action: AppButton(
            onPressed: () async {
              final ProductAttributeValue result = await Navigator.push<ProductAttributeValue>(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AttributeValuePriceDetailsAddEditPage(productTemplateId: widget.productTemplate.id),
                ),
              );

              if (result != null) {
                _attributeValuePriceBloc.add(AttributeValuePriceInitial(productTemplate: widget.productTemplate));
              }
            },
            width: null,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 40, 167, 69),
              borderRadius: BorderRadius.all(Radius.circular(24)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 23,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      S.of(context).addNewParam(S.of(context).attributePrice.toLowerCase()),
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  double getTextLength(String text, TextStyle textStyle) {
    const BoxConstraints constraints = BoxConstraints(
      maxWidth: 800.0,
      minHeight: 0.0,
      minWidth: 0.0,
    );

    final RenderParagraph renderParagraph = RenderParagraph(
      TextSpan(
        text: text,
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
    renderParagraph.layout(constraints);
    return renderParagraph.getMinIntrinsicWidth(textStyle.fontSize).ceilToDouble();
  }

  Widget _buildItem(ProductAttributeValue productAttributeValue, double maxWidth) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 80,
                    child: Text(
                      productAttributeValue.attributeName ?? '',
                      style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffF0F1F3),
                          borderRadius: BorderRadius.all(Radius.circular(13)),
                        ),
                        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4, top: 4),
                        child: Text(
                          productAttributeValue.name ?? '',
                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 13),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                Container(
                  width: maxWidth,
                  child: Text(
                    '+ ${productAttributeValue.priceExtra != null ? vietnameseCurrencyFormat(productAttributeValue.priceExtra) : '0'} đ',
                    textAlign: TextAlign.left,
                    style: const TextStyle(color: Color(0xff929DAA), fontSize: 14),
                  ),
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Color(0xffA7B2BF)),
                            onPressed: () async {
                              final ProductAttributeValue result = await Navigator.push<ProductAttributeValue>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AttributeValuePriceDetailsAddEditPage(
                                    productTemplateId: widget.productTemplate.id,
                                    productAttributeValue: productAttributeValue,
                                  ),
                                ),
                              );

                              if (result != null) {
                                _attributeValuePriceBloc
                                    .add(AttributeValuePriceInitial(productTemplate: widget.productTemplate));
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Material(
                          color: Colors.transparent,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Color(0xffA7B2BF)),
                            onPressed: () {
                              _attributeValuePriceBloc
                                  .add(AttributeValuePriceDelete(productAttributeValue: productAttributeValue));
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }
}
