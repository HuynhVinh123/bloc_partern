import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/odata_list_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';

abstract class ProductCategoryApi {
  /// Lấy danh sách nhóm sản phẩm
  /// https://tmt25.tpos.vn/odata/ProductCategory?$orderby=ParentLeft
  Future<OdataListResult<ProductCategory>> gets({OdataListQuery odataListQuery});


  Future<ProductCategory> getById(int id, {OdataObjectQuery query});

  Future<void> update(ProductCategory productCategory);

  Future<void> delete(int id);


  Future<void> setDelete(List<int> ids, bool isDelete);

  Future<ProductCategory> insert(ProductCategory productCategory);

  Future<ProductCategory> getDefault();
}
