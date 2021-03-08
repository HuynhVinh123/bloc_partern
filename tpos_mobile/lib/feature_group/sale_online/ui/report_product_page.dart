import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_product_bloc.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_product_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_product_state.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_loading_screen.dart';
import 'package:tpos_mobile/widgets/bloc_widget/bloc_ui_provider.dart';

/// Thống kê sản phẩm cho đơn hàng online(CHƯA SỬ DỤNG)
class ReportProductPage extends StatefulWidget {
  const ReportProductPage({this.saleOnlineOrders});
  final List<SaleOnlineOrder> saleOnlineOrders;
  @override
  _ReportProductPageState createState() => _ReportProductPageState();
}

class _ReportProductPageState extends State<ReportProductPage> {
  final ReportProductBloc _bloc = ReportProductBloc();

  @override
  void initState() {
    super.initState();
    _bloc.add(ReportProductLoaded(saleOnlineOrders: widget.saleOnlineOrders));
  }

  @override
  Widget build(BuildContext context) {
    return BlocUiProvider<ReportProductBloc>(
      listen: (state) {
        if (state is ReportProductFailure) {
          showError(
              title: state.title, message: state.content, context: context);
        }
      },
      bloc: _bloc,
      child: BlocLoadingScreen<ReportProductBloc>(
        busyStates: const [ReportProductLoading],
        child: Scaffold(
            appBar: AppBar(title: const Text("Sản phẩm đã bán")),
            body: BlocBuilder<ReportProductBloc, ReportProductState>(
                builder: (context, state) {
              if (state is ReportProductSuccess) {
                return Column(
                  children: [
                    Row(
                      children: const [
                        Expanded(
                            child: Text(
                          "Số lượng",
                          textAlign: TextAlign.center,
                        )),
                        Expanded(
                            child: Text(
                          "Tổng tiền",
                          textAlign: TextAlign.center,
                        )),
                      ],
                    ),
                    Expanded(child: _buildBody(state)),
                  ],
                );
              }
              return const SizedBox();
            })),
      ),
    );
  }

  Widget _buildBody(ReportProductSuccess state) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 1,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProductItem(reportProduct: state.reportProducts[index]);
      },
      itemCount: state.reportProducts.length,
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem({this.reportProduct});
  final ReportProduct reportProduct;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SizedBox(
        child: ListTile(
          title: Row(
            children: [
              Expanded(child: Text(reportProduct.product.productName ?? "")),
//              Text(
//                vietnameseCurrencyFormat(reportProduct.amountTotal),
//                style: const TextStyle(
//                  color: Colors.red,
//                ),
//              )
            ],
          ),
          subtitle: Row(
            children: [
              Expanded(
                  child: Text(
                reportProduct.qtyProduct.floor().toString(),
                style: const TextStyle(color: Colors.blue),
                textAlign: TextAlign.center,
              )),
              Expanded(
                  child: Text(
                vietnameseCurrencyFormat(reportProduct.amountTotal),
                style: const TextStyle(color: Colors.green),
                textAlign: TextAlign.center,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
