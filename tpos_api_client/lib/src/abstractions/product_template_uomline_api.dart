import '../../tpos_api_client.dart';

abstract class ProductTemplateUOMLineApi {
  /// Lấy danh sách sản phẩm
  Future<OdataListResult<Product>> getProductTemplateUOMLines(
      [OdataGetListQuery getListQuery]);
  Future<SaleOnlineOrder> getSaleOnlineOrderById(String id, [String expand]);
  Future<OdataListResult<FastSaleOrder>> getSaleOnlineOrders({int partnerId});
}
