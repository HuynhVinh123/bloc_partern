import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_product_event.dart';
import 'package:tpos_mobile/feature_group/sale_online/blocs/report_product_state.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

/// Thống kê sản phẩm cho đơn hàng online(CHƯA SỬ DỤNG)
class ReportProductBloc extends Bloc<ReportProductEvent, ReportProductState> {
  ReportProductBloc({
    ITposApiService tposApi,
  }) : super(ReportProductLoading()) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }

  ITposApiService _tposApi;
  @override
  Stream<ReportProductState> mapEventToState(ReportProductEvent event) async* {
    if (event is ReportProductLoaded) {}
  }
}

class ReportProduct {
  ReportProduct({this.product, this.amountTotal, this.qtyProduct = 0});
  SaleOnlineOrderDetail product;
  double qtyProduct;
  double amountTotal;
}
