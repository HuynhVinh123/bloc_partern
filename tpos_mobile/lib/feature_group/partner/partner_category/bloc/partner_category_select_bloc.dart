import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/partner/partner_category/bloc/partner_category_select_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import 'partner_category_select_event.dart';

class PartnerCategorySelectBloc
    extends Bloc<PartnerCategorySelectEvent, PartnerCategorySelectState> {
  PartnerCategorySelectBloc({PartnerCategoryApi partnerCategoryApi})
      : super(PartnerCategorySelectInitial()) {
    _partnerCategoryApi =
        partnerCategoryApi ?? GetIt.instance<PartnerCategoryApi>();
  }

  final Logger _logger = Logger();
  PartnerCategoryApi _partnerCategoryApi;
  List<PartnerCategory> _partnerCategories;
  String _keyWord = '';

  @override
  Stream<PartnerCategorySelectState> mapEventToState(
      PartnerCategorySelectEvent event) async* {
    if (event is PartnerCategorySelectLoaded) {
      yield* _getPartnerCategory();
    } else if (event is PartnerCategorySelectSearched) {
      yield* _searchPartnerCategory(event);
    }
  }

  /// load danh sách nhóm khách hàng
  Stream<PartnerCategorySelectState> _getPartnerCategory() async* {
    yield PartnerCategorySelectLoading();
    try {
      final OdataListQuery query = OdataListQuery(top: 10000);
      _partnerCategories =
          await _partnerCategoryApi.getList(odataListQuery: query);
      yield PartnerCategorySelectLoadSuccess(
          partnerCategories: _partnerCategories);
    } catch (e, s) {
      _logger.e('', e, s);
      yield PartnerCategorySelectLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  /// Tìm kiếm nhóm khách hàng
  Stream<PartnerCategorySelectState> _searchPartnerCategory(
      PartnerCategorySelectSearched event) async* {
    yield PartnerCategorySelectLoading();
    List<PartnerCategory> _partnerCategoriesSearch = <PartnerCategory>[];
    _keyWord = event.txtSearch.trim().toLowerCase();
    _partnerCategoriesSearch = _partnerCategories
        .where((PartnerCategory partnerCategory) =>
            partnerCategory.name.toLowerCase().contains(_keyWord) ||
            removeDiacritics(partnerCategory.name.toLowerCase())
                .contains(removeDiacritics(_keyWord)))
        .toList();

    yield PartnerCategorySelectLoadSuccess(
        partnerCategories: _partnerCategoriesSearch);
  }
}
