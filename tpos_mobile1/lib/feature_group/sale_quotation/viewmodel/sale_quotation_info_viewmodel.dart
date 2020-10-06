import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/order_line.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation_detail.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleQuotationInfoViewModel extends ViewModelBase {
  SaleQuotationInfoViewModel(
      {ITposApiService tposApiService, DialogService dialogService}) {
    _tposApi = tposApiService ?? locator<ITposApiService>();
    _dialog = dialogService ?? locator<DialogService>();
  }

  DialogService _dialog;
  ITposApiService _tposApi;

  List<OrderLines> _orderLines = [];
  List<OrderLines> get orderLines => _orderLines;
  set orderLines(List<OrderLines> value) {
    _orderLines = value;
    notifyListeners();
  }

  SaleQuotationDetail _saleQuotationDetail = SaleQuotationDetail();
  SaleQuotationDetail get saleQuotationDetail => _saleQuotationDetail;
  set saleQuotationDetail(SaleQuotationDetail value) {
    _saleQuotationDetail = value;
    notifyListeners();
  }

  Future<void> getInfoSaleQuotation(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getInfoSaleQuotation(id.toString());
      if (result != null) {
        saleQuotationDetail = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("loadInfoSaleQuotationsFail", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  Future<void> getOrderLines(int id) async {
    setState(true);
    try {
      final result = await _tposApi.getOrderLineForSaleQuotation(id.toString());
      if (result != null) {
        orderLines = result;
      }
      setState(false);
    } catch (e, s) {
      logger.error("getOrderLines", e, s);
      _dialog.showError(error: e);
      setState(false);
    }
  }

  double moneyDiscount() {
    double amountTotal = 0;
    for (int i = 0; i < _orderLines.length; i++) {
      amountTotal +=
          _orderLines[i].priceTotal * (_orderLines[i].discount / 100);
    }
    return amountTotal;
  }

  SaleQuotation setInfoSaleQuotation(SaleQuotation saleQuotation) {
    saleQuotation.id = saleQuotationDetail.id;
    saleQuotation.partner = saleQuotationDetail.partner?.displayName ?? "";
    saleQuotation.dateQuotation =
        "/Date(${DateTime.parse(saleQuotationDetail.dateQuotation).millisecondsSinceEpoch.toString()})/";
    print(saleQuotation.dateQuotation);
    saleQuotation.state = saleQuotationDetail.state;

    ///  Báo giá     Báo giá đã gửi
    saleQuotation.showState = saleQuotationDetail.state == "draft"
        ? S.current.quotation_quotation
        : S.current.quotation_quotationWasSent;
    saleQuotation.amountTotal = saleQuotationDetail.amountTotal;
    saleQuotation.user = saleQuotationDetail.user?.name;
    saleQuotation.partnerNameNoSign = saleQuotationDetail.partner?.name ?? "";
    return saleQuotation;
  }
}
