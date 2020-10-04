import 'package:tpos_api_client/tpos_api_client.dart';

abstract class CacheService {
  ApplicationUser loginUser;
  GetCompanyCurrentResult companyCurrent;
  ChangeCurrentCompanyGetResult companyCurrentWithBranch;
  ApplicationUser applicationUser;
  WebUserConfig webUserConfig;

  /// Get [PermissionFunctions] from webConfig
  List<String> get functions;

  /// Get [PermissionField] from WebConfig
  List<String> get fields;
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
}
