import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';

class BaseModelSaleQuotation {
  BaseModelSaleQuotation({this.totalItems, this.result});
  List<SaleQuotation> result;
  int totalItems;
}
