import 'package:tpos_api_client/src/model.dart';

abstract class ProductAttributeApi {
  /// Lấy ProductAttributeLine
  Future<OdataListResult< ProductAttribute>> getList({OdataListQuery query});

  Future<OdataListResult< ProductAttribute>> getProductAttributeLineList(int id, [String expand]);

  Future<ProductAttribute> getById(int id, {String expand = 'Attribute'});

  Future<void> update(ProductAttribute productAttributeLine);

  Future<void> delete(int id);

  Future<ProductAttribute> insert(ProductAttribute productAttributeLine);
}
