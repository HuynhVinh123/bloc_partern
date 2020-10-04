import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';

class BaseModelSaleQuotation {
  List<SaleQuotation> result;
  int totalItems;

  BaseModelSaleQuotation({this.totalItems, this.result});
}
