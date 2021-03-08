import 'package:tpos_api_client/src/models/entities/product/product_uom_category.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomCategoryApi {
  Future<OdataListResult<ProductUomCategory>> getList({OdataListQuery query});

  Future<ProductUomCategory> getById(int id, {OdataObjectQuery query});

  Future<void> update(ProductUomCategory productUomCategory);

  Future<void> delete(int id);

  Future<ProductUomCategory> insert(ProductUomCategory productUomCategory);
  
}
