import 'package:tpos_api_client/src/model.dart';

abstract class ProductAttributeValueApi {
  /// Lấy ProductAttributeValue
  Future<OdataListResult<ProductAttributeValue>> getList({GetProductAttributeForSearchQuery query});

  Future<void> update(ProductAttributeValue productAttribute);

  Future<void> delete(int id);

  Future<ProductAttributeValue> insert(ProductAttributeValue productAttribute);

  Future<ProductAttributeValue> getById(int id, {String expand = 'Attribute'});
}
