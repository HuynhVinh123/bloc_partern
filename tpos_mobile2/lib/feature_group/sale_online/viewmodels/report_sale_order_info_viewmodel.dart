import 'dart:async';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/report_order.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class ReportSaleOrderInfoViewModel extends ViewModel implements ViewModelBase {
  ReportSaleOrderInfoViewModel({ITposApiService tposApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
  }
  ITposApiService _tposApi;

  ReportSaleOrderInfo reportSaleOrderInfo;

  List<ReportSaleOrderLine> fastSaleOrderLines;

  Future _loadSaleOrderInfo(int id) async {
    onStateAdd(true, message: "Đang tải");
    fastSaleOrderLines = await _tposApi.getReportSaleOrderDetail(id);
    notifyListeners();
    onStateAdd(false);
  }

  Future<void> initCommand(int id) async {
    await _loadSaleOrderInfo(id);
  }
}
