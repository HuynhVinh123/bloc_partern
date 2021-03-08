import 'package:tpos_api_client/src/model.dart';

abstract class ProductVariantApi {
  Future<Product> getById(int id, {String expand});

  Future<void> update(Product product);

  Future<void> delete(int id);

  Future<Product> insert(Product product);

  Future<void> setActive(bool active, List<int> ids);
}
