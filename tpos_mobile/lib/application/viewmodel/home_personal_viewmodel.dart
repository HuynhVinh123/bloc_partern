import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/services/config_service/config_service.dart';
import 'package:tpos_mobile/services/config_service/shop_config_service.dart';

class HomePersonalViewModel extends ScopedViewModel {
  HomePersonalViewModel(
      {CommonApi commonApi,
      ApplicationUserApi applicationUserApi,
      ConfigService configService,
      ShopConfigService shopConfigService,
      SecureConfigService secureConfigService}) {
    _commonApi = commonApi ?? GetIt.instance<CommonApi>();
    _applicationUserApi =
        applicationUserApi ?? GetIt.instance<ApplicationUserApi>();
    _configService = configService ?? GetIt.instance<ConfigService>();
    _shopConfig = shopConfigService ?? GetIt.instance<ShopConfigService>();
    _secureConfig = secureConfigService ?? GetIt.I<SecureConfigService>();
  }
  CommonApi _commonApi;
  ApplicationUserApi _applicationUserApi;
  ConfigService _configService;
  SecureConfigService _secureConfig;
  ShopConfigService _shopConfig;

  final Logger _logger = Logger();

  /// Công ty hiện tại
  GetCompanyCurrentResult _company;

  /// Tài khoản đang đăng nhậpn
  ApplicationUser _applicationUser;

  /// Danh sachs công ty khả dụng. công ty đang chọn và ngày hết hạn sử dụng phần mềm
  ChangeCurrentCompanyGetResult _currentCompanyGetResult;

  ChangeCurrentCompanyGetResult get currentCompany => _currentCompanyGetResult;
  ApplicationUser get loginUser => _applicationUser;
  GetCompanyCurrentResult get company => _company;

  String get companyName =>
      currentCompany?.currentCompany ?? _shopConfig.companyName;

  String get shopUrl => _secureConfig.shopUrl ?? '';
  String get loginUsername => _secureConfig.shopUsername ?? '';

  /// Khởi tạo data. tải dữ liệu công ty, đăng nhập
  ///
  /// TODO Tối ưu chỗ này để không phải tải lại nhiều lần mỗi khi vào trang này. Nên cache lại hoặc chỉ tải 1 lần   dụng khởi chạy
  Future<void> initData() async {
    try {
      _company = await _commonApi.getCompanyCurrent();
      _currentCompanyGetResult =
          await _applicationUserApi.changeCurrentCompanyGet();

      _applicationUser = await _applicationUserApi.getCurrentUser();
      _shopConfig.setCompanyName(_currentCompanyGetResult.currentCompany);
      notifyListeners();
    } catch (e, s) {
      _logger.e('', e, s);
    }
  }

  void refreshData() {}
}
