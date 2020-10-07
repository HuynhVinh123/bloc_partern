import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/src/tpos_apis/models/delivery_carrier.dart';

import '../tpos_api.dart';

class FilterReportDelivery {
  FilterReportDelivery(
      {this.dateFrom,
      this.dateTo,
      this.isFilterByCompany = false,
      this.isFilterByPartner = false,
      this.partner,
      this.companyOfUser,
      this.filterDateRange,
      this.stateControl,
      this.isFilterShipState = false,
      this.isFilterControlState = false,
      this.isFilterDeliveryCarrier = false,
      this.deliveryCarrier,
      this.shipState,
      this.isFilterDeliveryCarrierType = false,
      this.deliveryCarrierType});

  DateTime dateFrom;
  DateTime dateTo;
  bool isFilterByCompany;
  bool isFilterByPartner;
  bool isFilterShipState;
  bool isFilterControlState;
  bool isFilterDeliveryCarrier;
  bool isFilterDeliveryCarrierType;
  AppFilterDateModel filterDateRange;
  DeliveryCarrier deliveryCarrier;
  String shipState;
  String stateControl;
  String deliveryCarrierType;
  Partner partner;
  CompanyOfUser companyOfUser;
}
