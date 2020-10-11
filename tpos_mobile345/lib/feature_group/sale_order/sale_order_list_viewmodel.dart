import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:tpos_mobile/src/tpos_apis/models/date_filter_template.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class SaleOrderListViewModel extends ViewModel {
  SaleOrderListViewModel({ITposApiService tposApi, SaleOrderApi saleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _saleOrderApi = saleOrderApi ?? locator<SaleOrderApi>();
  }

  ITposApiService _tposApi;
  SaleOrderApi _saleOrderApi;
  final Logger _log = Logger("SaleOrderViewModel");

  int take = 100;
  int skip = 0;
  int page = 1;
  int pageSize = 100;
  int saleOrderLength;

  String keyword = "";

  List<SaleOrder> saleOrders;
  // Lọc
  Future<void> filter() async {
    onStateAdd(true, message: S.current.loading);
    try {
      final result = await _saleOrderApi.getSaleOrderList(take, skip, keyword,
          _isFilterByDate ? toDate : null, _isFilterByDate ? fromDate : null);
      saleOrders = result.result;
      saleOrderLength = result.resultCount;
      tempSaleOrders = saleOrders;
    } catch (e, s) {
      _log.severe("filter", e, s);
    }
    notifyListeners();
    onStateAdd(false);
  }

  Future<bool> deleteSaleOrder(int id) async {
    onIsBusyAdd(true);
    try {
      final result = await _tposApi.deleteSaleOrder(id);
      if (result.result == true) {
        onDialogMessageAdd(OldDialogMessage.flashMessage(
            S.current.purchaseOrder_deleteSuccess));
        onIsBusyAdd(false);
        notifyListeners();
        return true;
      } else {
        onDialogMessageAdd(OldDialogMessage.error("", result.message));
        return false;
      }
    } catch (ex, stack) {
      _log.severe("deleteSaleOrder fail", ex, stack);
      onDialogMessageAdd(OldDialogMessage.error("", ex.toString(),
          title: S.current.exception));
      return false;
    }
  }

  Future<void> initCommand() async {
    try {
      _initDateFilter();
      await filter();
    } catch (e, s) {
      _log.severe("init sale order list", e, s);
    }
  }

  Future init() async {
    onStateAdd(true, message: S.current.loading);
    await filter();
    notifyListeners();
    onStateAdd(false);
  }

  // CHECK ĐIỀU KIỆN LỌC FILTER
  bool _isFilterByDate = false;
  bool get isFilterByDate => _isFilterByDate;
  set isFilterByDate(bool value) {
    _isFilterByDate = value;
    notifyListeners();
  }

  // Lọc theo ngày
  List<DateFilterTemplate> filterByDates;
  DateFilterTemplate selectedFilterByDate;
  DateTime fromDate;
  DateTime toDate;

  void _initDateFilter() {
    filterByDates = <DateFilterTemplate>[];
// HÔM NAY
    filterByDates.add(
      DateFilterTemplate(
        name: "${S.current.today} ",
        fromDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        toDate: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 23, 59, 59, 99, 999),
      ),
    );
// HÔM QUA
    toDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999,
    ).add(const Duration(days: -1));

    fromDate = toDate.add(const Duration(days: -1)).add(const Duration(
          milliseconds: 1,
        ));
    filterByDates.add(
      DateFilterTemplate(
        name: "${S.current.yesterday} ",
        toDate: toDate,
        fromDate: fromDate,
      ),
    );
// 7 NGÀY GẦN NHẤT
    toDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999,
    );

    fromDate = toDate
        .add(const Duration(days: -7))
        .add(const Duration(milliseconds: 1));
    filterByDates.add(
      DateFilterTemplate(
        name: S.current.filter_7daysAgo,
        toDate: toDate,
        fromDate: fromDate,
      ),
    );

    // 30 NGÀY GẦN NHẤT
    toDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999,
    );

    fromDate = toDate
        .add(const Duration(days: -30))
        .add(const Duration(milliseconds: 1));
    filterByDates.add(
      DateFilterTemplate(
        name: S.current.filter_30daysAgo,
        toDate: toDate,
        fromDate: fromDate,
      ),
    );
    // Tất cả
    filterByDates.add(
      DateFilterTemplate(
        name: S.current.filter_fullTime,
        toDate: null,
        fromDate: null,
      ),
    );
    selectedFilterByDate = filterByDates.first;
    fromDate = selectedFilterByDate.fromDate;
    toDate = selectedFilterByDate.toDate;
  }

  void selectFilterByDateCommand(DateFilterTemplate date) {
    take = 100;
    skip = 0;
    selectedFilterByDate = date;
    fromDate = date.fromDate;
    toDate = date.toDate;
    notifyListeners();
  }

  Future<void> updateFromDateCommand(DateTime date) async {
    fromDate = date;
    notifyListeners();
  }

  Future<void> updateFromDateTimeCommand(TimeOfDay time) async {
    if (fromDate != null)
      fromDate = DateTime(
          fromDate.year, fromDate.month, fromDate.day, time.hour, time.minute);
    notifyListeners();
  }

  Future<void> updateToDateCommand(DateTime date) async {
    toDate = date;
    notifyListeners();
  }

  Future<void> updateToDateTimeCommand(TimeOfDay time) async {
    if (toDate != null)
      toDate = DateTime(
          toDate.year, toDate.month, toDate.day, time.hour, time.minute);
    notifyListeners();
  }

  bool get canLoadMore {
    if (take + skip == saleOrderLength) {
      return false;
    }
    return saleOrderLength > 100 && skip < saleOrderLength;
  }

  // Load more sale order list
  Future<void> loadMoreSaleOrder() async {
    if (saleOrderLength - (skip + take) < 100) {
      take = saleOrderLength - (skip + take);
      skip = saleOrderLength - take;
    } else {
      skip += 100;
    }

    onStateAdd(true, message: S.current.loading);
    final result = await _saleOrderApi.getSaleOrderList(take, skip, keyword,
        _isFilterByDate ? toDate : null, _isFilterByDate ? fromDate : null);
    if (result != null) {
      saleOrders.addAll(result.result);
    }
    notifyListeners();
    onStateAdd(false);
  }

  List<SaleOrder> tempSaleOrders = <SaleOrder>[];
  void setSaleOrderCommand(SaleOrder value, int index) {
    saleOrders[index] = value;
    notifyListeners();
  }

//searchKeyword
  Future<void> onSearchingOrderHandled(String keyword) async {
    if (keyword == null || keyword == "") {
      saleOrders = tempSaleOrders;
      notifyListeners();
    }
    try {
      final String key = StringUtils.removeVietnameseMark(keyword);
      saleOrders = tempSaleOrders
          // ignore: avoid_bool_literals_in_conditional_expressions
          .where((f) => f.name != null
              ? StringUtils.removeVietnameseMark(f.name.toLowerCase())
                      .contains(key.toLowerCase()) ||
                  f.partnerNameNoSign
                      .toString()
                      .toLowerCase()
                      .contains(key.toLowerCase()) ||
                  f.name.toString().toLowerCase().contains(key.toLowerCase())
              : false)
          .toList();
      notifyListeners();
    } catch (ex) {
      onDialogMessageAdd(OldDialogMessage.error("", ex.toString()));
    }
  }

  int get filterCount {
    int filterCount = 0;
    if (_isFilterByDate) {
      filterCount = 1;
    }
    return filterCount;
  }

  int sortColumnIndex;
  bool sortAscending = true;

  void sortSaleOrders<T>(
      Comparable<T> getField(SaleOrder d), bool ascending, int columnIndex) {
    saleOrders.sort((SaleOrder a, SaleOrder b) {
      if (!ascending) {
        final SaleOrder c = a;
        a = b;
        b = c;
      }
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return Comparable.compare(aValue, bValue);
    });
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    notifyListeners();
  }

  void removeFilter() {
    selectedFilterByDate = filterByDates.last;
    fromDate = toDate = null;
    _isFilterByDate = false;
    notifyListeners();
  }
}
