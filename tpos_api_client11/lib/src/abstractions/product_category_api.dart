import 'package:tpos_api_client/src/model.dart';

abstract class ProductCategoryApi {
  /// Lấy danh sách nhóm sản phẩm
  /// https://tmt25.tpos.vn/odata/ProductCategory?$orderby=ParentLeft
  Future<OdataListResult<ProductCategory>> gets();
}
