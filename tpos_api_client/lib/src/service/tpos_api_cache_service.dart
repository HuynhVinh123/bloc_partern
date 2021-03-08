import 'package:async/async.dart';

import '../../tpos_api_client.dart';

class TPosApiCacheService {
  /// Cache the partner status
  AsyncCache<List<PartnerStatus>> _cachePartnerStatus;

  AsyncCache<List<PartnerStatus>> get cachePartnerStatus =>
      _cachePartnerStatus ??
      (_cachePartnerStatus = AsyncCache<List<PartnerStatus>>(
        const Duration(minutes: 10),
      ));

  AsyncCache<Map<String, dynamic>> _partnerStatusMapCache;

  AsyncCache<Map<String, dynamic>> get partnerStatusMapCache =>
      _partnerStatusMapCache ??
      (_partnerStatusMapCache = AsyncCache<Map<String, dynamic>>(
        const Duration(minutes: 10),
      ));
}
