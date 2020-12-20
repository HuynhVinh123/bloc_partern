import 'package:test/test.dart';
import 'package:tpos_mobile/services/tpos_desktop_api_service.dart';

TPosDesktopService _tposDesktop =
    new TPosDesktopService(computerIp: "192.168.1.113", computerPort: "8123");

void main() {
  test("printFastSaleOrderShipTest", _testPrintShip);
}

Future _testPrintShip() async {
//  var result = await _printSv.printFastSaleOrderShip(
//      carrierId: 2, fastSaleOrderId: 40426);
}
