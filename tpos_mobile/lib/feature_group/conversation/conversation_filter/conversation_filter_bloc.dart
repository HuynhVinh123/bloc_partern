import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/app_filter_helper.dart';
import 'package:tpos_mobile/app_core/template_models/app_filter_date_model.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_event.dart';
import 'package:tpos_mobile/feature_group/conversation/conversation_filter/conversation_filter_state.dart';

class ConversationFilterBloc
    extends Bloc<ConversationFilterEvent, ConversationFilterState> {
  ConversationFilterBloc() : super(ConversationFilterLoading()) {
    _filterToDate = _filterDateRange.toDate;
    _filterFromDate = _filterDateRange.fromDate;
  }

  final bool _isFilterByDate = false;
  DateTime _filterFromDate;
  DateTime _filterToDate;
  bool _isFilterHasPhone;
  bool _isFilterHasAddress;
  bool _isFilterConservationUnread;
  bool _isHasOrder;

  final AppFilterDateModel _filterDateRange = getTodayDateFilter();
  List<ApplicationUser> _filterListApplicationUser;
  @override
  Stream<ConversationFilterState> mapEventToState(
      ConversationFilterEvent event) async* {
    if (event is ConversationFilterLoaded) {
      ///  Load dữ liệu khi load page lần đầu
      yield ConversationFilterLoadSuccess(
          filterFromDate: _filterFromDate,
          filterToDate: _filterToDate,
          filterDateRange: _filterDateRange,
          isFilterByDate: _isFilterByDate,
          isFilterHasPhone: _isFilterHasPhone,
          isFilterHasAddress: _isFilterHasAddress,
          isHasOrder: _isHasOrder,
          isFilterConservationUnread: _isFilterConservationUnread,
          isConfirm: false,
          applicationUserSelect: _filterListApplicationUser);
    } else if (event is ConversationFilterChanged) {
      /// update lại dữ liệu mỗi lần thay đổi filter
      try {
        yield ConversationFilterLoadSuccess(
            filterFromDate: event.filterFromDate,
            filterToDate: event.filterToDate,
            filterDateRange: event.filterDateRange,
            isFilterByDate: event.isFilterByDate,
            isFilterConservationUnread: event.isFilterConservationUnread,
            isFilterHasAddress: event.isFilterHasAddress,
            isFilterHasPhone: event.isFilterHasPhone,
            isHasOrder: event.isHasOrder,
            isConfirm: event.isConfirm,
            isByStaff: event.isByStaff,
            applicationUserSelect: event.applicationUserList,
            crmTagSelect: event.crmTagList,
            isCheckTag: event.isCheckTag);
      } catch (e) {
        yield ConversationFilterLoadSuccess(
            filterFromDate: event.filterFromDate,
            filterToDate: event.filterToDate,
            filterDateRange: event.filterDateRange,
            isFilterByDate: event.isFilterByDate,
            isFilterConservationUnread: event.isFilterConservationUnread,
            isFilterHasAddress: event.isFilterHasAddress,
            isFilterHasPhone: event.isFilterHasPhone,
            isHasOrder: event.isHasOrder,
            isConfirm: event.isConfirm,
            isByStaff: event.isByStaff,
            applicationUserSelect: event.applicationUserList,
            crmTagSelect: event.crmTagList,
            isCheckTag: event.isCheckTag);
      }
    }
  }
}
