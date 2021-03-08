import 'package:diacritic/diacritic.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/partner_category_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/partner_category_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerCategoryBloc
    extends Bloc<PartnerCategoryEvent, PartnerCategoryState> {
  PartnerCategoryBloc({PartnerCategoryApi partnerCategoryApi})
      : super(PartnerCategoryLoading()) {
    _partnerCategoryApi =
        partnerCategoryApi ?? GetIt.instance<PartnerCategoryApi>();
  }

  final Logger _logger = Logger();
  PartnerCategoryApi _partnerCategoryApi;
  String _keyWord = '';
  List<PartnerCategory> _partnerCategories = [];

  @override
  Stream<PartnerCategoryState> mapEventToState(
      PartnerCategoryEvent event) async* {
    if (event is PartnerCategoriesLoaded) {
      yield* _getPartnerCategory();
    } else if (event is PartnerCategorySearched) {
      yield* _searchPartnerCategory(event);
    } else if (event is PartnerCategoryDeleted) {
      yield* _deletePartnerCategory(event);
    }
  }

  /// load danh sách danh mục khách hàng
  Stream<PartnerCategoryState> _getPartnerCategory() async* {
    yield PartnerCategoryLoading();
    try {
      final OdataListQuery query = OdataListQuery(top: 10000);
      _partnerCategories =
          await _partnerCategoryApi.getList(odataListQuery: query);
      yield PartnerCategoryLoadSuccess(partnerCategories: _partnerCategories);
    } catch (e, s) {
      _logger.e('', e, s);
      yield PartnerCategoryLoadFailure(
          title: S.current.notification, content: e.toString());
    }
  }

  /// Tìm kiếm danh mục khách hàng
  Stream<PartnerCategoryState> _searchPartnerCategory(event) async* {
    yield PartnerCategoryLoading();
    List<PartnerCategory> _partnerCategoriesSeach = [];
    _keyWord = event.search.trim().toLowerCase();
    _partnerCategoriesSeach = _partnerCategories
        .where((PartnerCategory partnerCategory) =>
            partnerCategory.name.toLowerCase().contains(_keyWord) ||
            removeDiacritics(partnerCategory.name.toLowerCase())
                .contains(removeDiacritics(_keyWord)))
        .toList();

    yield PartnerCategoryLoadSuccess(
        partnerCategories: _partnerCategoriesSeach);
  }

  /// Xóa danh mục khách hàng
  Stream<PartnerCategoryState> _deletePartnerCategory(event) async* {
    yield PartnerCategoryBusy();
    try {
      await _partnerCategoryApi.delete(event.partnerCategory.id);
      _partnerCategories.remove(event.partnerCategory);
      print(_partnerCategories.length);
      yield PartnerCategoryDeleteSuccess(partnerCategories: _partnerCategories);
    } catch (e, s) {
      _logger.e('', e, s);
      yield PartnerCategoryActionFailure(error: e.toString());
    }
  }
}
