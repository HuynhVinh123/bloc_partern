import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/entities/product/product_price_list.dart';

/// API Client để thực hiện cá thao tác CRUD với bảng giá sản phẩm
abstract class PriceListApi {
  /// Get all product price
  ///
  /// GET /odata/Product_PriceList?%24format=json&%24count=true HTTP/1.1
  Future<OdataListResult<ProductPrice>> gets({bool count = true});

  /// Lấy danh sách bảng giá theo thời gian hiện tại
  ///
  /// odata/Product_PriceList/ODataService.GetPriceListAvailable
  Future<OdataListResult<ProductPrice>> getPriceListAvailable(
      {DateTime data, String format, bool count});

  /// Xóa bảng giá
  ///
  /// odata/Product_PriceList($priceListId)
  Future<void> delete(int priceListId);
}
