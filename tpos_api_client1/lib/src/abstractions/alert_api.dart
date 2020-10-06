import 'package:tpos_api_client/src/models/entities/alert.dart';

abstract class AlertApi {
  Future<Alert> getAlert();
}
