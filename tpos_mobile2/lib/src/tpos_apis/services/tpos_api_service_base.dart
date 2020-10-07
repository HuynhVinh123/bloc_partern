import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/log_services/log_service.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_client.dart';

class ApiServiceBase {
  LogService _logService;
  TposApiClient _apiClient;
  LogService get logger => _logService;
  TposApiClient get apiClient => _apiClient;
  ApiServiceBase({LogService logService, TposApiClient apiClient}) {
    _logService = logService ?? locator<LogService>();
    _apiClient = apiClient ?? locator<TposApiClient>();
  }
}
