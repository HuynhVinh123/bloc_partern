import 'package:test/test.dart';
import 'package:tpos_mobile/services/tpos_desktop_api_service.dart';

import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';

TposApiService _sv = new TposApiService(
  shopUrl: "https://tmt25.tpos.vn",
  accessToken:
      "ejotuJcqnahw9DTmJjtccLEhqPnyukfXKdBskbbWSLReqyUuWYqtI3zgKBGV2faenMXoF8Qlb7-oKxZqa7_fcjl0EW9YpeZS9bX_kaj7VSKjCtUEWovQRNHSsxdPlDgca4j5FcKtIoVdiQav-jXNe-v74m9pieD-d_IK2Ydnav4xhtNP5TTzqdLdl7HV6OAeb_ift3Z0yfuRMDuMSZxfjnG84qqcs2gr9ofpyoaxormJt_2SjTIBuRA-fMlnKo7pMjf48iz3Mywjw5uuPAq63ltqtTaQiLYlxZ_AovHsQ22YlT52jaDEeY0PUPhUllZQK6_HjKZCBf2E4refOAcv5IhRC6BK6J5w0b8tN6bYhJrLr5t8x0A4ePhev34OCMFoN31hsXDO9Rivv4FrdbJtIMgzW4g4us4oo1Oj_1gXnmdphNkdEaJu2SgN18TRtr1z",
);

TPosDesktopService _tposDesktop =
    new TPosDesktopService(computerIp: "192.168.1.113", computerPort: "8123");

void main() {
  test("printFastSaleOrderShipTest", _testPrintShip);
}

Future _testPrintShip() async {
//  var result = await _printSv.printFastSaleOrderShip(
//      carrierId: 2, fastSaleOrderId: 40426);
}
