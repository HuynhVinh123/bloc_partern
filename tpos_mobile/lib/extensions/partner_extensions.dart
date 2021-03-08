import 'dart:ui';

import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/helpers/app_helper.dart';

extension PartnerExtensions on Partner {
  Color getStatusColor() {
    return getPartnerStatusColorFromStatusText(statusText);
  }
}
