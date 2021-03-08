import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/partner_ext/bloc/partner_ext_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_ext/bloc/partner_ext_state.dart';

///Bloc dùng để lấy danh sách [PartnerExt] hiện có
class PartnerExtBloc extends Bloc<PartnerExtEvent, PartnerExtState> {
  PartnerExtBloc({PartnerExtApi partnerExtApi}) : super(PartnerExtLoading(partnerExts: [])) {
    _partnerExtApi = partnerExtApi ?? GetIt.I<PartnerExtApi>();
  }

  PartnerExtApi _partnerExtApi;
  List<PartnerExt> _partnerExts = [];
  final Logger _logger = Logger();
  String _search = '';

  @override
  Stream<PartnerExtState> mapEventToState(PartnerExtEvent event) async* {
    if (event is PartnerExtStarted) {
      try {
        yield PartnerExtLoading(partnerExts: _partnerExts);
        _search = removeDiacritics(event.keyword.trim());
        if (event.keyword == '') {
          final OdataListResult<PartnerExt> result = await _partnerExtApi.getList();
          _partnerExts = result.value;
        } else {
          final GetPartnerExtForSearchQuery query = GetPartnerExtForSearchQuery(keyword: _search);
          final OdataListResult<PartnerExt> result = await _partnerExtApi.getList(query: query);
          _partnerExts = result.value;
        }

        yield PartnerExtLoadSuccess(partnerExts: _partnerExts);
      } catch (e, stack) {
        _logger.e('PartnerExtLoadFailure', e, stack);
        yield PartnerExtLoadFailure(error: e.toString(), partnerExts: _partnerExts);
      }
    } else if (event is PartnerExtSearched) {
      try {
        final String search = removeDiacritics(event.keyword.trim());
        if (_search != search) {
          yield PartnerExtBusy(partnerExts: _partnerExts);
          if (event.keyword == '') {
            final OdataListResult<PartnerExt> result = await _partnerExtApi.getList();
            _partnerExts = result.value;
          } else {
            final GetPartnerExtForSearchQuery query = GetPartnerExtForSearchQuery(keyword: search);
            final OdataListResult<PartnerExt> result = await _partnerExtApi.getList(query: query);
            _partnerExts = result.value;
          }

          yield PartnerExtLoadSuccess(partnerExts: _partnerExts);
        }
      } catch (e, stack) {
        _logger.e('PartnerExtLoadFailure', e, stack);
        yield PartnerExtLoadFailure(error: e.toString(), partnerExts: _partnerExts);
      }
    }
  }
}
