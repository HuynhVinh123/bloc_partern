import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_bloc.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_state.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/custom_dropdown.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile/widgets/money_format_controller.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

typedef ObjectToString<T> = String Function(T value);

class StockChangeProductQuantityPage extends StatefulWidget {
  const StockChangeProductQuantityPage({Key key, this.productTemplateId}) : super(key: key);

  @override
  _StockChangeProductQuantityPageState createState() => _StockChangeProductQuantityPageState();
  final int productTemplateId;
}

class _StockChangeProductQuantityPageState extends State<StockChangeProductQuantityPage> {
  StockChangeProductQuantityBloc _stockChangeProductQuantityBloc;
  StockChangeProductQuantity _stockChangeProductQuantity;
  List<Product> _products;
  List<StockLocation> _stockLocations;
  List<StockProductionLot> _stockProductionLots;
  final CustomMoneyMaskedTextController _numberController = CustomMoneyMaskedTextController(
      minValue: 0, precision: 0, thousandSeparator: '.', decimalSeparator: '', defaultValue: 0);
  final bool _change = false;
  @override
  void initState() {
    _stockChangeProductQuantityBloc = StockChangeProductQuantityBloc();
    _stockChangeProductQuantityBloc.add(StockChangeProductQuantityInitial(productTemplateId: widget.productTemplateId));
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    _stockChangeProductQuantityBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        S.of(context).editAvailableInventory,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      actions: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              save();
            })
      ],
    );
  }

  Widget _buildBody() {
    return BaseBlocListenerUi<StockChangeProductQuantityBloc, StockChangeProductQuantityState>(
      bloc: _stockChangeProductQuantityBloc,
      loadingState: StockChangeProductQuantityLoading,
      busyState: StockChangeProductQuantityBusy,
      errorState: StockChangeProductQuantityLoadFailure,
      buildWhen: (StockChangeProductQuantityState last, StockChangeProductQuantityState current) {
        return current is! StockChangeProductQuantitySaveError;
      },
      errorBuilder: (BuildContext context, StockChangeProductQuantityState state) {
        String error = S.of(context).canNotGetDataFromServer;
        if (state is StockChangeProductQuantityLoadFailure) {
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
                    _stockChangeProductQuantityBloc
                        .add(StockChangeProductQuantityInitial(productTemplateId: widget.productTemplateId));
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
      listener: (BuildContext context, StockChangeProductQuantityState state) {
        if (state is StockChangeProductQuantitySaveSuccess) {
          _stockChangeProductQuantity = state.stockChangeProductQuantity;
          _numberController.text = _stockChangeProductQuantity.newQuantity != null
              ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
              : '';
          Navigator.of(context).pop(_stockChangeProductQuantity);
        } else if (state is StockChangeProductQuantityLoadSuccess) {
          _stockChangeProductQuantity = state.stockChangeProductQuantity;
          _numberController.text = _stockChangeProductQuantity.newQuantity != null
              ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
              : '';
        } else if (state is StockChangeProductQuantitySaveError) {
          App.showDefaultDialog(
              title: S.of(context).error, context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      builder: (BuildContext context, StockChangeProductQuantityState state) {
        if (state is StockChangeProductQuantityLoadSuccess) {
          _stockChangeProductQuantity = state.stockChangeProductQuantity;
          _products = state.products;
          _stockLocations = state.locations;
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 10),
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          return _buildSelectDropdown(
                              title: S.of(context).product,
                              hint: S.of(context).selectParam(S.of(context).product.toLowerCase()),
                              objects: _products,
                              selectValue: _stockChangeProductQuantity.product,
                              objectToString: (Product product) {
                                return product?.nameGet;
                              },
                              onSelected: (Product product) {
                                _stockChangeProductQuantity.product = product;
                                _stockChangeProductQuantityBloc.add(StockChangeProductQuantityUpdateLocal(
                                    stockChangeProductQuantity: _stockChangeProductQuantity));
                                setState(() {});
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          return _buildSelectDropdown(
                              title: S.of(context).address,
                              hint: S.of(context).selectParam(S.of(context).address.toLowerCase()),
                              objects: _stockLocations,
                              selectValue: _stockChangeProductQuantity.location,
                              objectToString: (StockLocation stockLocation) {
                                return stockLocation?.nameGet;
                              },
                              onSelected: (StockLocation stockLocation) {
                                _stockChangeProductQuantity.location = stockLocation;
                                _stockChangeProductQuantityBloc.add(StockChangeProductQuantityUpdateLocal(
                                    stockChangeProductQuantity: _stockChangeProductQuantity));
                                setState(() {});
                              });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
                      child: StatefulBuilder(
                        builder: (BuildContext context, void Function(void Function()) setState) {
                          return _buildSelectDropdown(
                              title: S.of(context).lotAndSeri,
                              hint: S.of(context).selectParam(S.of(context).lotAndSeri.toLowerCase()),
                              objects: _stockProductionLots ?? <StockProductionLot>[],
                              selectValue: _stockChangeProductQuantity.productionLot,
                              objectToString: (StockProductionLot stockProductionLot) {
                                return '';
                              },
                              onSelected: (StockProductionLot stockProductionLot) {
                                _stockChangeProductQuantity.productionLot = stockProductionLot;
                                _stockChangeProductQuantityBloc.add(StockChangeProductQuantityUpdateLocal(
                                    stockChangeProductQuantity: _stockChangeProductQuantity));
                                setState(() {});
                              });
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
                        child: _buildQuantity()),
                    // Padding(
                    //     padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 10), child: _buildNote()),
                    // Padding(
                    //     padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
                    //     child: _buildInputName(error: errorName)),
                    // Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildSelectParent()),
                    // Padding(padding: const EdgeInsets.only(left: 16, right: 12), child: _buildPropertyCostMethod()),
                    // Padding(padding: const EdgeInsets.only(left: 16, right: 16), child: _buildSequence()),
                    // Padding(padding: const EdgeInsets.only(left: 10, right: 16), child: _buildCheckPos()),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: _buildButton(),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        );
      },
    );
  }

  ///Xây dựng giao diện chọn với drop down
  Widget _buildSelectDropdown<T>(
      {@required String title,
      @required String hint,
      List<T> objects,
      T selectValue,
      ObjectToString<T> objectToString,
      Function(T value) onSelected}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)), color: Color.fromARGB(255, 248, 249, 251)),
              child: CustomDropdown<T>(
                  selectedValue: selectValue,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.only(bottom: 3, left: 5),
                        alignment: Alignment.centerLeft,
                        child: Text(selectValue != null ? objectToString(selectValue) : hint,
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            style: const TextStyle(color: Color(0xff5A6271), fontSize: 17)),
                      ),
                      const Icon(Icons.arrow_drop_down),
                      // const SizedBox(width: 10),
                    ],
                  ),
                  onSelected: (T selectedOrderBy) {
                    onSelected?.call(selectedOrderBy);
                  },
                  itemBuilder: (BuildContext context) => objects
                      .map((T action) => PopupMenuItem<T>(
                            value: action,
                            child: Text(
                              objectToString(action),
                              style: const TextStyle(color: Color(0xff5A6271), fontSize: 17),
                            ),
                          ))
                      .toList()),
            )
          ],
        ),
        const SizedBox(height: 5),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }

  ///Xây dựng giao diện nhập số lượng thực tế
  Widget _buildQuantity() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(S.of(context).availableQuantity, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Color(0xff28A745),
                        ),
                        onPressed: () {
                          if (_stockChangeProductQuantity.newQuantity > 0) {
                            _stockChangeProductQuantity.newQuantity -= 1;
                            _numberController.text = _stockChangeProductQuantity.newQuantity != null
                                ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
                                : '';
                            setState(() {});
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: InkWell(
                        onTap: () async {
                          _numberController.text = _stockChangeProductQuantity.newQuantity != null
                              ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
                              : '';
                          final String value = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return _buildDialogInputs(
                                  context: context,
                                  title: S.of(context).availableQuantity,
                                  hint: S.of(context).enterParam(S.of(context).availableQuantity.toLowerCase()));
                            },
                            useRootNavigator: false,
                          );

                          if (value != null) {
                            _stockChangeProductQuantity.newQuantity = _numberController.numberValue;
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: const Color(0xffE9EDF2))),
                          child: Text(
                            _numberController.text,
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                          ),
                        ),
                      )),
                      const SizedBox(width: 10),
                      AppButton(
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Color(0xff28A745),
                        ),
                        onPressed: () {
                          _stockChangeProductQuantity.newQuantity += 1;
                          _numberController.text = _stockChangeProductQuantity.newQuantity != null
                              ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
                              : '';
                          setState(() {});
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(color: Colors.grey.shade200, height: 1, width: double.infinity),
        const SizedBox(height: 10),
      ],
    );
  }

  ///Giao diện nút lưu
  Widget _buildButton() {
    return AppButton(
      width: double.infinity,
      onPressed: () {
        save();
      },
      background: const Color(0xff28A745),
      child: Text(
        S.of(context).apply,
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

  ///Giao diện dialog nhập thông tin
  Widget _buildDialogInputs({@required BuildContext context, @required String title, @required String hint}) {
    assert(context != null);
    assert(title != null);
    assert(hint != null);

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2,
      child: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                color: Colors.white,
              ),
              // padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(color: Color(0xff2C333A), fontSize: 21),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: IconButton(
                                    iconSize: 30,
                                    icon: const Icon(
                                      Icons.close,
                                      color: Color(0xff929DAA),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }),
                              ),
                            ),
                            const SizedBox(width: 0)
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Column(
                            children: [
                              StatefulBuilder(
                                builder: (BuildContext context, void Function(void Function()) setState) {
                                  return Container(
                                    height: 50,
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 15,
                                          left: 5,
                                          child: SvgPicture.asset(
                                            'assets/icon/tag_green.svg',
                                            width: 20,
                                            height: 20,
                                            // color: Colors.transparent,
                                          ),
                                        ),
                                        if (_numberController.text != '')
                                          Positioned(
                                            top: 13,
                                            left: 30,
                                            child: Row(
                                              children: [
                                                Text(_numberController.text,
                                                    style: const TextStyle(color: Colors.transparent, fontSize: 17)),
                                                const SizedBox(width: 10),
                                              ],
                                            ),
                                          ),
                                        TextField(
                                          controller: _numberController,
                                          autofocus: true,
                                          maxLines: 1,
                                          onChanged: (String text) {
                                            setState(() {});
                                          },
                                          style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.only(right: 10, left: 5, bottom: 5),
                                            prefix: Padding(
                                              padding: const EdgeInsets.only(right: 10, bottom: 0),
                                              child: SvgPicture.asset(
                                                'assets/icon/tag_green.svg',
                                                width: 20,
                                                height: 20,
                                                color: Colors.transparent,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: Colors.grey.shade200),
                                            ),
                                            hintText: hint,
                                            hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                                            focusedBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(color: Color(0xff28A745)),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: const Color(0xffC6C6C6), width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(left: 40, right: 40),
                                      child: Center(
                                        child: Text(
                                          S.of(context).cancel,
                                          style: const TextStyle(color: Color(0xff3A3B3F)),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: const Color(0xff28A745), width: 1)),
                                    child: FlatButton(
                                      padding: const EdgeInsets.only(left: 60, right: 60),
                                      child: Center(
                                        child: Text(
                                          S.of(context).save,
                                          style: const TextStyle(color: Color(0xff28A745)),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context, _numberController.text);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///Lưu thông tin
  void save() {
    if (_stockChangeProductQuantity != null) {
      _stockChangeProductQuantityBloc
          .add(StockChangeProductQuantitySaved(stockChangeProductQuantity: _stockChangeProductQuantity));
    } else {
      App.showDefaultDialog(
          title: S.of(context).error,
          context: context,
          type: AlertDialogType.error,
          content: S.of(context).canNotGetData);
    }
  }
}
