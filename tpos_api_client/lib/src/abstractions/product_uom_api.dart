import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomApi {
  Future<OdataListResult<ProductUOM>> getList({OdataListQuery query});


  Future<ProductUOM> getById(int id, {OdataObjectQuery query});

  Future<void> update(ProductUOM productCategory);

  Future<void> delete(int id);

  Future<ProductUOM> insert(ProductUOM productCategory);

  Future<ProductUOM> getDefault();
  
}
