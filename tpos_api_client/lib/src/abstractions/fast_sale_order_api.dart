import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/get_fast_sale_order_by_id_query.dart';
import 'package:tpos_api_client/src/models/requests/get_fast_sale_order_query.dart';

abstract class FastSaleOrderApi {
  /// Lấy danh sách 'Hóa đơn bán hàng' theo API
  Future<OdataListResult<FastSaleOrder>> gets(GetFastSaleOrderQuery query);

  /// Lấy danh sách ' Hóa đơn giao hàng'
  Future<OdataListResult<FastSaleOrder>> getDeliveryInvoices(
      GetFastSaleOrderQuery query);
  Future<FastSaleOrder> getById(int id, {GetFastSaleOrderByIdQuery query});

  /// Lấy một FastSaleOrder mặc định theo server để thêm một [FastSaleOrder] mới
  Future<FastSaleOrder> getDefault({
    OdataObjectQuery query,
    List<String> saleOrderIds,
    String type = 'invoice',
  });

  /// Lấy thông tin hóa đơn khi thay đổi khách hàng
  /// Cập nhật lại bảng giá, Cấu hình giao hàng
  /// Dùng cho chức năng tạo hóa đơn bán hàng nhanh
  Future<FastSaleOrder> getOnChangePartnerOrPriceList(
      FastSaleOrder fastSaleOrder);

  Future<FastSaleOrder> insert(FastSaleOrder insert);
  Future<void> update(FastSaleOrder order);
  Future<String> printOkialaShip(int invoiceId);

  Future<CreateQuickFastSaleOrderModel> getQuickCreateFastSaleOrderDefault(
      List<String> saleOnlineIds);

  Future<InsertOrderProductDefaultResult> createQuickFastSaleOrder(
      CreateQuickFastSaleOrderModel model);
}
