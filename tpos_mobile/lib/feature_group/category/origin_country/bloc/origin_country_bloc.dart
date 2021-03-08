import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/origin_country/bloc/origin_country_event.dart';
import 'package:tpos_mobile/feature_group/category/origin_country/bloc/origin_country_state.dart';

class OriginCountryBloc extends Bloc<OriginCountryEvent, OriginCountryState> {
  OriginCountryBloc({OriginCountryApi originCountryApi}) : super(OriginCountryLoading(originCountrys: [])) {
    _originCountryApi = originCountryApi ?? GetIt.I<OriginCountryApi>();
  }

  OriginCountryApi _originCountryApi;
  List<OriginCountry> _originCountrys = [];
  final Logger _logger = Logger();

  @override
  Stream<OriginCountryState> mapEventToState(OriginCountryEvent event) async* {
    if (event is OriginCountryStarted) {
      try {
        final OdataListResult<OriginCountry> result = await _originCountryApi.getList();
        _originCountrys = result.value;
        yield OriginCountryLoadSuccess(originCountrys: _originCountrys);
      } catch (e, stack) {
        _logger.e('OriginCountryLoadFailure', e, stack);
        yield OriginCountryLoadFailure(error: e.toString(), originCountrys: _originCountrys);
      }
    } else if (event is OriginCountrySearched) {
      try {
        yield OriginCountryBusy(originCountrys: _originCountrys);
        final GetOriginCountryForSearchQuery query = GetOriginCountryForSearchQuery(keyword: event.keyword);
        final OdataListResult<OriginCountry> result = await _originCountryApi.getList(query: query);
        _originCountrys = result.value;
        yield OriginCountryLoadSuccess(originCountrys: _originCountrys);
      } catch (e, stack) {
        _logger.e('OriginCountryLoadFailure', e, stack);
        yield OriginCountryLoadFailure(error: e.toString(), originCountrys: _originCountrys);
      }
    }
  }
}
