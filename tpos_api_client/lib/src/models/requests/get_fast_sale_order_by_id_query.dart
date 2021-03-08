import 'package:tpos_api_client/src/model.dart';

class GetFastSaleOrderByIdQuery extends OdataObjectQuery {
  GetFastSaleOrderByIdQuery({List<String> expands}) : super(expands: expands);

  /// Tạo query để lấy [FastSaleOrder] để xem thông tin hoặc chỉnh sửa thông tin
  factory GetFastSaleOrderByIdQuery.allInfo() {
    return GetFastSaleOrderByIdQuery(expands: [
      'Partner',
      'User',
      'Warehouse',
      'Company',
      'PriceList',
      'RefundOrder',
      'Account',
      'Journal',
      'PaymentJournal',
      'Carrier',
      'Tax',
      'SaleOrder',
      'HistoryDeliveryDetails',
      'OrderLines(\$expand=Product,ProductUOM,Account,SaleLine,User)',
      'Ship_ServiceExtras',
      'OutstandingInfo(\$expand=Content)',
    ]);
  }
}
