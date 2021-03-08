import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_event.dart';
import 'package:tpos_mobile/feature_group/category/partner_category/bloc/add_edit/partner_category_add_edit_state.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PartnerCategoryAddEditBloc
    extends Bloc<PartnerCategoryAddEditEvent, PartnerCategoryAddEditState> {
  PartnerCategoryAddEditBloc({PartnerCategoryApi partnerCategoryApi})
      : super(PartnerCategoryAddEditLoading()) {
    _partnerCategoryApi = partnerCategoryApi ?? GetIt.I<PartnerCategoryApi>();
  }

  PartnerCategoryApi _partnerCategoryApi;
  PartnerCategory _category;
  final Logger _logger = Logger();

  @override
  Stream<PartnerCategoryAddEditState> mapEventToState(
      PartnerCategoryAddEditEvent event) async* {
    if (event is PartnerCategoryAddEditLoaded) {
      yield* _loaded(event);
    } else if (event is PartnerCategoryAddEditSaved) {
      yield* _saved(event);
    }
  }

  /// load list danh mục khách hàng
  Stream<PartnerCategoryAddEditState> _loaded(
      PartnerCategoryAddEditLoaded event) async* {
    yield PartnerCategoryAddEditLoading();
    try {
      if (event.partnerCategory != null) {
        final OdataObjectQuery query = OdataObjectQuery(expand: 'Parent');
        _category = await _partnerCategoryApi.getById(event.partnerCategory.id,
            query: query);
        yield PartnerCategoryAddEditLoadSuccess(partnerCategory: _category);
      } else {
        final PartnerCategory _categoryNew = PartnerCategory();
        _categoryNew.id = 0;
        _categoryNew.discount = 0;
        yield PartnerCategoryAddEditLoadSuccess(partnerCategory: _categoryNew);
      }
    } catch (e, s) {
      _logger.e('', e, s);
      yield PartnerCategoryAddEditLoadFailure(message: e.toString());
    }
  }

  /// Sửa danh mục khách hàng
  Stream<PartnerCategoryAddEditState> _saved(
      PartnerCategoryAddEditSaved event) async* {
    yield PartnerCategoryAddEditBusy();
    try {
      _category = event.partnerCategory;
      if (_category.name == '' || _category.name == null) {
        yield PartnerCategoryAddEditNameError(
            partnerCategory: _category, error: S.current.pleaseEnterGroupName);
      } else {
        if (_category.id == 0) {
          final result = await _partnerCategoryApi.insert(_category);
          _category = result;
          yield PartnerCategoryAddSaveSuccess(partnerCategory: _category);
        } else {
          await _partnerCategoryApi.update(_category);
          yield PartnerCategoryEditSaveSuccess(partnerCategory: _category);
        }
      }
    } catch (e, s) {
      _logger.e('', e, s);
      yield PartnerCategoryAddEditSaveError(
          title: S.current.notification, message: e.toString());
    }
  }
}
