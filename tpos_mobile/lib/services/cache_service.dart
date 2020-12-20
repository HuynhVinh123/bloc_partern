import 'package:tpos_api_client/tpos_api_client.dart';

abstract class CacheService {
  ApplicationUser loginUser;
  GetCompanyCurrentResult companyCurrent;
  ChangeCurrentCompanyGetResult companyCurrentWithBranch;
  ApplicationUser applicationUser;
  WebUserConfig webUserConfig;
  List<Product> products;

  /// Get [PermissionFunctions] from webConfig
  List<String> get functions;

  /// Get [PermissionField] from WebConfig
  List<String> get fields;

  List<Product> get getProducts;

  set setProducts(List<Product> product);

  void clearProducts();
}

class MemoryCacheService implements CacheService {
  ApplicationUser loginUser;

  @override
  ApplicationUser applicationUser;

  @override
  GetCompanyCurrentResult companyCurrent;

  @override
  WebUserConfig webUserConfig;

  /// Get [PermissionFunctions] from webConfig
  List<String> get functions => webUserConfig?.functions ?? <String>[];

  /// Get [PermissionField] from WebConfig
  List<String> get fields => webUserConfig?.fields ?? <String>[];

  @override
  ChangeCurrentCompanyGetResult companyCurrentWithBranch;

  @override
  List<Product> products;

  @override
  set setProducts(List<Product> product) {
    products = product;
  }

  @override
  void clearProducts() {
    products = null;
  }

  @override
  List<Product> get getProducts => products ?? <Product>[];
}
