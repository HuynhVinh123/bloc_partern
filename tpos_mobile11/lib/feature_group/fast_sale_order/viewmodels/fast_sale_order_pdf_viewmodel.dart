import 'dart:async';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/locator.dart';


import 'package:tpos_mobile/src/tpos_apis/services/object_apis/fast_sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/tpos_api.dart';

class FastSaleOrderPDFViewModel extends ViewModel implements ViewModelBase {
  FastSaleOrderPDFViewModel(
      {TposApiService tposApi, FastSaleOrderApi fastSaleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _fastSaleOrderApi = fastSaleOrderApi ?? locator<FastSaleOrderApi>();
  }

  ITposApiService _tposApi;
  FastSaleOrderApi _fastSaleOrderApi;

  FastSaleOrder _order;
  FastSaleOrder get order => _order;

  set order(FastSaleOrder value) {
    order = value;
  }

  Future<FastSaleOrder> refreshFastSaleOrderInfo(int id) async {
    _order = await _fastSaleOrderApi.getFastSaleOrderForPDF(id);
//    var first = _order.orderLines.first;
//    _order.orderLines.addAll(List.generate(90, (i) => first));
    return order;
  }

  int get totalQuantity {
    double totalQuantity = 0;
    for (final f in order.orderLines) {
      totalQuantity = totalQuantity + f.productUOMQty;
    }
    return totalQuantity.toInt();
  }

  Future<String> getBarcodeTrackingRef() async {
    String url;
    if (order.carrierId == 1) {
      url = await _tposApi.getBarcodeShip(order.trackingRef.substring(15));
    } else {
      url = await _tposApi.getBarcodeShip(order.trackingRef);
    }
    return url;
  }

  Future<String> getBarcodeTrackingRefSort() async {
    final url = await _tposApi.getBarcodeShip(order.trackingRefSort);
    return url;
  }
}
