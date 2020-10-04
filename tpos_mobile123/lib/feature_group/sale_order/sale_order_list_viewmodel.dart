import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:tmt_flutter_untils/sources/string_utils/string_utils.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/feature_group/sale_order/sale_order.dart';
import 'package:tpos_mobile/helpers/messenger_helper.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

import 'package:tpos_mobile/src/tpos_apis/models/date_filter_template.dart';
import 'package:tpos_mobile/src/tpos_apis/services/object_apis/sale_order_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';

class SaleOrderListViewModel extends ViewModel {
  ITposApiService _tposApi;
  SaleOrderApi _saleOrderApi;
  Logger _log = new Logger("SaleOrderViewModel");

  SaleOrderListViewModel({ITposApiService tposApi, SaleOrderApi saleOrderApi}) {
    _tposApi = tposApi ?? locator<ITposApiService>();
    _saleOrderApi = saleOrderApi ?? locator<SaleOrderApi>();
  }

  int take = 100;
  int skip = 0;
  int page = 1;
  int pageSize = 100;
  int saleOrderLength;

  String keyword = "";

  List<SaleOrder> saleOrders;
  // Lọc
  Future<void> filter() async {
    onStateAdd(true, message: "Đang tải");
    try {
      var result = await _saleOrderApi.getSaleOrderList(take, skip, keyword,
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
      var result = await _tposApi.deleteSaleOrder(id);
      if (result.result == true) {
        onDialogMessageAdd(
            new OldDialogMessage.flashMessage("Đã xóa đơn đặt hàng"));
        onIsBusyAdd(false);
        notifyListeners();
        return true;
      } else {
        onDialogMessageAdd(new OldDialogMessage.error("", result.message));
        return false;
      }
    } catch (ex, stack) {
      _log.severe("deleteSaleOrder fail", ex, stack);
      onDialogMessageAdd(new OldDialogMessage.error("", ex.toString(),
          title: "Lỗi không xác định!"));
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
    onStateAdd(true, message: "Đang tải");
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
    filterByDates = new List<DateFilterTemplate>();
// HÔM NAY
    filterByDates.add(
      new DateFilterTemplate(
        name: "Hôm nay ",
        fromDate: new DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 0, 0, 0),
        toDate: new DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 23, 59, 59, 99, 999),
      ),
    );
// HÔM QUA
    toDate = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999,
    ).add(Duration(days: -1));

    fromDate = toDate.add(new Duration(days: -1)).add(new Duration(
          milliseconds: 1,
        ));
    filterByDates.add(
      new DateFilterTemplate(
        name: "Hôm qua ",
        toDate: toDate,
        fromDate: fromDate,
      ),
    );
// 7 NGÀY GẦN NHẤT
    toDate = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999,
    );

    fromDate =
        toDate.add(new Duration(days: -7)).add(new Duration(milliseconds: 1));
    filterByDates.add(
      new DateFilterTemplate(
        name: "7 ngày gần nhất ",
        toDate: toDate,
        fromDate: fromDate,
      ),
    );

    // 30 NGÀY GẦN NHẤT
    toDate = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
      59,
      999,
    );

    fromDate =
        toDate.add(new Duration(days: -30)).add(new Duration(milliseconds: 1));
    filterByDates.add(
      new DateFilterTemplate(
        name: "30 ngày gần nhất ",
        toDate: toDate,
        fromDate: fromDate,
      ),
    );
    // Tất cả
    filterByDates.add(
      new DateFilterTemplate(
        name: "Toàn thời gian",
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
      fromDate = new DateTime(
          fromDate.year, fromDate.month, fromDate.day, time.hour, time.minute);
    notifyListeners();
  }

  Future<void> updateToDateCommand(DateTime date) async {
    this.toDate = date;
    notifyListeners();
  }

  Future<void> updateToDateTimeCommand(TimeOfDay time) async {
    if (toDate != null)
      toDate = new DateTime(
          toDate.year, toDate.month, toDate.day, time.hour, time.minute);
    notifyListeners();
  }

  bool get canLoadMore {
    if (take + skip == saleOrderLength) return false;
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

    onStateAdd(true, message: "Đang tải");
    var result = await _saleOrderApi.getSaleOrderList(take, skip, keyword,
        _isFilterByDate ? toDate : null, _isFilterByDate ? fromDate : null);
    if (result != null) saleOrders.addAll(result.result);
    notifyListeners();
    onStateAdd(false);
  }

  List<SaleOrder> tempSaleOrders = new List<SaleOrder>();
  setSaleOrderCommand(SaleOrder value, int index) {
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
      String key = (StringUtils.removeVietnameseMark(keyword));
      saleOrders = tempSaleOrders
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

  get filterCount {
    int filterCount = 0;
    if (_isFilterByDate) filterCount = 1;
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
