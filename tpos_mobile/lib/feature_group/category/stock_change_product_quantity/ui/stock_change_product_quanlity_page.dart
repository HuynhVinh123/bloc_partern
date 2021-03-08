import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_bloc.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_event.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/bloc/stock_change_product_quantity_state.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/ui/product_variant_search_page.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/ui/stock_location_search_page.dart';
import 'package:tpos_mobile/feature_group/category/stock_change_product_quantity/ui/stock_product_lot_search_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_change_product_quantity.dart';
import 'package:tpos_mobile/src/tpos_apis/models/stock_location.dart';
import 'package:tpos_mobile/widgets/bloc_widget/base_bloc_listener_ui.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile/widgets/dialog/number_input_dialog.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
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

  @override
  void initState() {
    _stockChangeProductQuantityBloc = StockChangeProductQuantityBloc();
    _stockChangeProductQuantityBloc.add(StockChangeProductQuantityInitial(productTemplateId: widget.productTemplateId));
    super.initState();
  }

  @override
  void dispose() {
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
        S.current.editAvailableInventory,
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
      errorBuilder: (BuildContext context, StockChangeProductQuantityState state) {
        String error = S.current.canNotGetDataFromServer;
        if (state is StockChangeProductQuantityLoadFailure) {
          error = state.error ?? S.current.canNotGetDataFromServer;
        }
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
              LoadStatusWidget(
                statusName: S.current.loadDataError,
                content: error,
                statusIcon: SvgPicture.asset('assets/icon/error.svg', width: 170, height: 130),
                action: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AppButton(
                    onPressed: () {
                      _stockChangeProductQuantityBloc
                          .add(StockChangeProductQuantityInitial(productTemplateId: widget.productTemplateId));
                    },
                    width: null,
                    padding: const EdgeInsets.only(left: 20, right: 20),
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
                            S.current.refreshPage,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                          ),
                        ],
                      ),
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
          Navigator.of(context).pop(_stockChangeProductQuantity);
        } else if (state is StockChangeProductQuantityLoadSuccess) {
          _stockChangeProductQuantity = state.stockChangeProductQuantity;
        } else if (state is StockChangeProductQuantitySaveError) {
          App.showDefaultDialog(
              title: S.current.error, context: context, type: AlertDialogType.error, content: state.error);
        } else if (state is StockChangeProductQuantityProductChangeError) {
          App.showDefaultDialog(
              title: S.current.error, context: context, type: AlertDialogType.error, content: state.error);
        }
      },
      builder: (BuildContext context, StockChangeProductQuantityState state) {
        if (state is StockChangeProductQuantityLoadSuccess) {
          _stockChangeProductQuantity = state.stockChangeProductQuantity;
          _products = state.products;
          _stockLocations = state.locations;
          _stockProductionLots = state.stockProductionLots;
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return _buildNavigate(
                            title: S.current.product,
                            value: _stockChangeProductQuantity.product != null
                                ? _stockChangeProductQuantity.product?.nameGet
                                : S.current.selectParam(S.current.product.toLowerCase()),
                            onSelected: () async {
                              final Product product = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductVariantSearchPage(
                                      products: _products,
                                    );
                                  },
                                ),
                              );
                              if (product != null) {
                                if (_stockChangeProductQuantity.product?.id != product.id) {
                                  _stockChangeProductQuantityBloc.add(StockChangeProductQuantityProductChanged(
                                      product: product, stockChangeProductQuantity: _stockChangeProductQuantity));
                                }
                              }
                            },
                            style: _stockChangeProductQuantity.product != null
                                ? const TextStyle(color: Color(0xff2C333A), fontSize: 17)
                                : const TextStyle(color: Color(0xff929DAA), fontSize: 17));
                      },
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return _buildNavigate(
                            title: S.current.location,
                            value: _stockChangeProductQuantity.location != null
                                ? _stockChangeProductQuantity.location?.nameGet
                                : S.current.selectParam(S.current.product.toLowerCase()),
                            onSelected: () async {
                              final StockLocation stockLocation = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return StockLocationSearchPage(
                                      stockLocations: _stockLocations,
                                    );
                                  },
                                ),
                              );
                              if (stockLocation != null) {
                                _stockChangeProductQuantity.location = stockLocation;
                                _stockChangeProductQuantityBloc.add(StockChangeProductQuantityUpdateLocal(
                                    stockChangeProductQuantity: _stockChangeProductQuantity));
                                setState(() {});
                              }
                            },
                            style: _stockChangeProductQuantity.location != null
                                ? const TextStyle(color: Color(0xff2C333A), fontSize: 17)
                                : const TextStyle(color: Color(0xff929DAA), fontSize: 17));
                      },
                    ),
                    StatefulBuilder(
                      builder: (BuildContext context, void Function(void Function()) setState) {
                        return _buildNavigate(
                            title: S.current.lotAndSeri,
                            value: _stockChangeProductQuantity.productionLot != null
                                ? _stockChangeProductQuantity.productionLot?.name
                                : S.current.selectParam(S.current.lotAndSeri.toLowerCase()),
                            onSelected: () async {
                              final StockProductionLot stockProductionLot = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return StockProductionLotSearchPage(
                                      stockProductionLots: _stockProductionLots,
                                    );
                                  },
                                ),
                              );
                              if (stockProductionLot != null) {
                                _stockChangeProductQuantity.productionLot = stockProductionLot;
                                _stockChangeProductQuantity.lotId = stockProductionLot.id;
                                _stockChangeProductQuantityBloc.add(StockChangeProductQuantityUpdateLocal(
                                    stockChangeProductQuantity: _stockChangeProductQuantity));
                                setState(() {});
                              }
                            },
                            style: _stockChangeProductQuantity.productionLot != null
                                ? const TextStyle(color: Color(0xff2C333A), fontSize: 17)
                                : const TextStyle(color: Color(0xff929DAA), fontSize: 17));
                      },
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
                        child: _buildQuantity()),
                    const SizedBox(height: 80),
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

  Widget _buildNavigate({@required String title, @required String value, TextStyle style, Function() onSelected}) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              onSelected?.call();
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 13, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20, top: 0),
                          child: Text(title, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10, top: 0),
                            child: Text(value ?? '',
                                style: style ?? const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 14,
                      color: Color(0xffA7B2BF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
            color: Colors.grey.shade200,
            height: 1,
            width: double.infinity,
            margin: const EdgeInsets.only(left: 16, right: 16)),
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
            Text(S.current.availableQuantity, style: const TextStyle(color: Color(0xff2C333A), fontSize: 17)),
            const SizedBox(width: 10),
            Expanded(
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) setState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        width: 50,
                        height: null,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: Color(0xff28A745),
                        ),
                        onPressed: () {
                          _stockChangeProductQuantity.newQuantity ??= 0;
                          _stockChangeProductQuantity.newQuantity -= 1;
                          // _numberController.text = _stockChangeProductQuantity.newQuantity != null
                          //     ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
                          //     : '';
                          setState(() {});
                        },
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                          child: InkWell(
                        onTap: () async {
                          _stockChangeProductQuantity.newQuantity ??= 0;
                          final double number = await showNumberInputDialog(
                              context, _stockChangeProductQuantity.newQuantity.toDouble(),
                              allowNegative: true);
                          if (number != null) {
                            _stockChangeProductQuantity.newQuantity = number;
                            setState(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(13),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                              border: Border.all(color: const Color(0xffE9EDF2))),
                          child: Text(
                            _stockChangeProductQuantity.newQuantity != null
                                ? _stockChangeProductQuantity.newQuantity.toStringAsFixed(0)
                                : '0',
                            style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                          ),
                        ),
                      )),
                      const SizedBox(width: 10),
                      AppButton(
                        width: 50,
                        height: null,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(6)),
                            border: Border.all(color: const Color(0xffE9EDF2))),
                        child: const Icon(
                          Icons.arrow_drop_up,
                          color: Color(0xff28A745),
                        ),
                        onPressed: () {
                          _stockChangeProductQuantity.newQuantity ??= 0;
                          _stockChangeProductQuantity.newQuantity += 1;
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
        S.current.apply,
        style: const TextStyle(fontSize: 18, color: Colors.white),
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
          title: S.current.error, context: context, type: AlertDialogType.error, content: S.current.canNotGetData);
    }
  }
}
