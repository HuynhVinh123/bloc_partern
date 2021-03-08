import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
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

  Map<String, dynamic> get partnerStatus;
  void setPartnerStatus(Map<String, dynamic> value);
  Future<void> refreshPartnerStatus();
}

class MemoryCacheService implements CacheService {
  final Logger _logger = Logger();
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

  Map<String, dynamic> _partnerStatus = <String, dynamic>{};

  void setPartnerStatus(Map<String, dynamic> value) {
    _partnerStatus = value;
  }

  Map<String, dynamic> get partnerStatus => _partnerStatus;

  Future<void> refreshPartnerStatus() async {
    final _api = GetIt.I<CommonApi>();
    try {
      _partnerStatus = await _api.getPartnerStatusMap(cache: true);
    } catch (e, s) {
      _partnerStatus = <String, dynamic>{};
      _logger.e('Fetch partner status to cache failed.', e, s);
    }
  }
}
