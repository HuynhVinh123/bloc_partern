import 'package:tpos_api_client/tpos_api_client.dart';

abstract class PartnerExtState {
  PartnerExtState({this.partnerExts});

  final List<PartnerExt> partnerExts;
}

class PartnerExtLoading extends PartnerExtState {
  PartnerExtLoading({List<PartnerExt> partnerExts}) : super(partnerExts: partnerExts);
}


class PartnerExtBusy extends PartnerExtState {
  PartnerExtBusy({List<PartnerExt> partnerExts}) : super(partnerExts: partnerExts);
}


class PartnerExtLoadSuccess extends PartnerExtState {
  PartnerExtLoadSuccess({List<PartnerExt> partnerExts}) : super(partnerExts: partnerExts);
}

class PartnerExtLoadFailure extends PartnerExtState {
  PartnerExtLoadFailure({List<PartnerExt> partnerExts, this.error}) : super(partnerExts: partnerExts);
  final String error;
}
