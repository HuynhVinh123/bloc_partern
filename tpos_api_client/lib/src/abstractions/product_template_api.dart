import 'package:flutter/cupertino.dart';
import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/get_product_template_query.dart';
import 'package:tpos_api_client/src/models/results/get_product_template_result.dart';

abstract class ProductTemplateApi {
  /// Lấy danh sách sản phẩm
  /// https://tmt25.tpos.vn/ProductTemplate/List
  Future<GetProductTemplateResult> getList({int priceId, String tagIds, GetProductTemplateQuery query});

  /// Lấy sản phẩm theo id
  /// https://tmt25.tpos.vn/odata/ProductTemplate(42830)?$expand=UOM,UOMCateg,Categ,UOMPO,POSCateg,Taxes,SupplierTaxes,Product_Teams,Images,UOMView,Distributor,Importer,Producer,OriginCountry
  Future<ProductTemplate> getById(int id, [String expand]);

  Future<OdataListResult<InventoryProduct>> getInventoryProducts([GetProductTemplateInventoryQuery query]);

  ///Lấy thông tin mặc định khi thêm sản phẩm
  Future<ProductTemplate> getDefault([String expand]);

  Future<ProductTemplate> insert(ProductTemplate data);

  Future<void> update(ProductTemplate data);

  Future<void> delete(int id);

  Future<void> deletes(List<int> ids);

  Future<ProductTemplate> getByDetails(int id, [String expand]);

  Future<void> setActive(bool active, List<int> ids);

  ///Lấy danh sách giá trị biến thể của sản phẩm
  Future<OdataListResult<ProductAttributeValue>> getAttributeValues(int id, [OdataGetListQuery getListQuery]);

  ///Lấy danh sách giá biến thể
  Future<ProductAttributeValue> getVariantPrice({@required int id, @required int attributeValueId, String expand});

  ///Lấy danh sách biến thể
  Future<OdataListResult<Product>> getVariants({@required int id, OdataGetListQuery getListQuery});

  ///Cập nhật thông tin giá biến thể
  Future<void> updateVariantPrice({@required int id, @required ProductAttributeValue productAttributeValue});

  ///Thêm giá biến thể
  Future<ProductAttributeValue> insertVariantPrice({@required int id, @required ProductAttributeValue productAttributeValue});
}
