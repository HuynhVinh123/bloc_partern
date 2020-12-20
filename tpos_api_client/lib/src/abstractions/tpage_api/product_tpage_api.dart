import 'package:tpos_api_client/src/models/entities/product/product.dart';
import 'package:tpos_api_client/src/models/entities/tpage/crm_tag.dart';

abstract class ProductTPageApi {
  Future<List<Product>> getProductTPage({int skip, int top, String keyWord});

  Future<List<Product>> getProductIsAvailable(
      {bool isFilter, int skip, int top});

  Future<void> updateStatusProductTPage(String productId);
}
