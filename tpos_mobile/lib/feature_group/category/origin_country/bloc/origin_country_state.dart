import 'package:tpos_api_client/tpos_api_client.dart';

abstract class OriginCountryState {
  OriginCountryState({this.originCountrys});

  final List<OriginCountry> originCountrys;
}

class OriginCountryLoading extends OriginCountryState {
  OriginCountryLoading({List<OriginCountry> originCountrys}) : super(originCountrys: originCountrys);
}


class OriginCountryBusy extends OriginCountryState {
  OriginCountryBusy({List<OriginCountry> originCountrys}) : super(originCountrys: originCountrys);
}


class OriginCountryLoadSuccess extends OriginCountryState {
  OriginCountryLoadSuccess({List<OriginCountry> originCountrys}) : super(originCountrys: originCountrys);
}

class OriginCountryLoadFailure extends OriginCountryState {
  OriginCountryLoadFailure({List<OriginCountry> originCountrys, this.error}) : super(originCountrys: originCountrys);
  final String error;
}
