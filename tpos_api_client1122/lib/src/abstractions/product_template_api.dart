import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/get_product_template_query.dart';
import 'package:tpos_api_client/src/models/requests/odata_query.dart';

///TODO(sangcv): Triển khai ProductTemplateAPi => ProductTemplateApiImpl
abstract class ProductTemplateApi {
  /// Lấy danh sách sản phẩm
  /// https://tmt25.tpos.vn/ProductTemplate/List
  Future<List<ProductTemplate>> getList(GetProductTemplateQuery query);

  /// Lấy sản phẩm theo id
  /// https://tmt25.tpos.vn/odata/ProductTemplate(42830)?$expand=UOM,UOMCateg,Categ,UOMPO,POSCateg,Taxes,SupplierTaxes,Product_Teams,Images,UOMView,Distributor,Importer,Producer,OriginCountry
  Future<ProductTemplate> getById(int id, [OdataObjectQuery query]);

  Future<ProductTemplate> insert(ProductTemplate data);
  Future<void> update(ProductTemplate data);
  Future<void> delete(int id);

  /// TODO(sangcv): other
}
