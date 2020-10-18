import 'dart:core';

import 'package:intl/intl.dart';
import 'package:tpos_mobile/locator.dart';

import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';
import 'package:tpos_mobile/feature_group/fast_purchase_order/helper/data_helper.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order.dart';
import 'package:tpos_mobile/src/tpos_apis/models/fast_purchase_order_payment.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api.dart';
import 'package:tpos_mobile/src/tpos_apis/services/tpos_api_interface.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class FastPurchaseOrderViewModel extends ViewModel {
  FastPurchaseOrderViewModel();
  bool isRefund = false;
  List<FastPurchaseOrder> list = <FastPurchaseOrder>[];
  List<FastPurchaseOrder> listForDisplay = <FastPurchaseOrder>[];
  FastPurchaseOrder currentOrder;
  final TposApiService _tposApi = locator<ITposApiService>();
  FastPurchaseOrderSort fastPurchaseOrderSort = FastPurchaseOrderSort();
  double totalAmount = 0.0;
  var take = 200;
  var skip = 0;
  var page = 1;
  var pageSize = 200;
  var sort = <Map>[];
  FastPurchaseFilterDateTime filterDate = FastPurchaseFilterDateTime();
  FastPurchaseFilterDateTime filterDateTemp = FastPurchaseFilterDateTime();
  Map filter;
  List<String> listFilterState = <String>[];
  List<String> listFilterStateTemp = <String>[];
  String result = S.current.loading;
  int countState = 0;
  String tempStateFilterName;
  String tempTimeFilterName;
  String tempFromDate;
  String tempToDate;
  List<int> listPickedItem = <int>[];
  bool isPickToDeleteMode = false;
  FastPurchaseOrderPayment fastPurchaseOrderPayment;

  void init() {
    if (list != null) {
      list.clear();
      listForDisplay.clear();
      filterDate = FastPurchaseFilterDateTime();
      filterDateTemp = FastPurchaseFilterDateTime();
      listFilterState.clear();
      listFilterStateTemp.clear();
      result = "";
      listPickedItem.clear();
      isPickToDeleteMode = false;
    }

    notifyListeners();
  }

  Future loadData() async {
    if (list != null) {
      list.clear();
      listForDisplay = list;
    }
    tempStateFilterName = null;
    tempTimeFilterName = null;
    countState = 0;
    result = S.current.loading;
    notifyListeners();
    listFilterState.clear();
    // ignore: avoid_function_literals_in_foreach_calls
    listFilterStateTemp.forEach((f) {
      listFilterState.add(f);
    });

    filterDate = FastPurchaseFilterDateTime.fromJson(filterDateTemp.toJson());

    sort = [
      {
        "field": fastPurchaseOrderSort.field,
        "dir": fastPurchaseOrderSort.dir,
      },
    ];
    final filterList = <Map>[];
    // Điều kiện lọc trạng thái
    final filterStatusListMap = <Map>[];

    if (filterDate.fromDate != null) {
      filterList.add({
        "field": "DateInvoice",
        "operator": "gte",
        "value": DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterDate.fromDate),
      });
      tempFromDate =
          DateFormat("dd/MM/yyyyTHH:mm:ss").format(filterDate.fromDate);
    }

    if (filterDate.toDate != null) {
      filterList.add({
        "field": "DateInvoice",
        "operator": "lte",
        "value": DateFormat("yyyy-MM-ddTHH:mm:ss").format(filterDate.toDate),
      });
      tempToDate = DateFormat("dd/MM/yyyyTHH:mm:ss").format(filterDate.toDate);
    }

    tempTimeFilterName = filterDate.name;

    if (listFilterState.isNotEmpty) {
      // ignore: avoid_function_literals_in_foreach_calls
      listFilterState.forEach((item) {
        countState++;
        tempStateFilterName = convertStateName2(item);
        filterStatusListMap.add({
          "field": "State",
          "operator": "eq",
          "value": item,
        });
      });

      filterList.add({
        "logic": "or",
        "filters": filterStatusListMap,
      });
    }
    // Điều kiện lọc
    filter = {
      "logic": "and",
      "filters": filterList,
    };

    filterList.add({
      "field": "Type",
      "operator": "eq",
      "value": isRefund ? "refund" : "invoice"
    });
    filter = {
      "logic": "and",
      "filters": filterList,
    };
    try {
      list = await _tposApi.getFastPurchaseOrderList(
          take, skip, page, pageSize, sort, filter);
      listForDisplay = list;
      result = listForDisplay == null || listForDisplay.isEmpty
          ? "${S.current.fastPurchase_noInvoice} \n"
              " ${listFilterStateTemp.isNotEmpty ? listFilterStateTemp.map((state) => "${getStateVietnamese(state)} ") : ""} \n"
              " ${filterDateTemp != null && getDate(filterDateTemp.fromDate) != null ? "${S.current.from} ${getDate(filterDateTemp.fromDate)} ${S.current.to} ${getDate(filterDateTemp.toDate)}" : ""}"
          : S.current.hasData;
      notifyListeners();
    } catch (e, s) {
      result = e.toString();
      logger.error("", e, s);
      notifyListeners();
    }
  }

  void updateTotalAmount() {
    if (listForDisplay != null) {
      double total = 0;
      for (final item in listForDisplay) {
        total = total + item.amountTotal;
      }
      totalAmount = total;
    }
  }

  @override
  void notifyListeners() {
    updateTotalAmount();
    super.notifyListeners();
  }

  Future<void> onSortChange(String text) async {
    if (text == fastPurchaseOrderSort.field) {
      fastPurchaseOrderSort.dir =
          fastPurchaseOrderSort.dir == "desc" ? "asc" : "desc";
    } else {
      fastPurchaseOrderSort.field = text;
    }
    loadData();
  }

  void resetFilter() {
    filterDateTemp = FastPurchaseFilterDateTime();
    listFilterStateTemp.clear();
    loadData();
  }

  void resetFilterState() {
    listFilterStateTemp.clear();
    notifyListeners();
  }

  void resetFilterTime() {
    filterDateTemp = FastPurchaseFilterDateTime();
    notifyListeners();
  }

  void onTapStateBtn(String state) {
    state = convertStateName(state);
    if (state != null) {
      if (!listFilterStateTemp.contains(state)) {
        listFilterStateTemp.add(state);
      } else {
        listFilterStateTemp.remove(state);
      }
      notifyListeners();
    }
  }

  void onCloseStateDropDown() {
    listFilterStateTemp.clear();
    print("$listFilterStateTemp = $listFilterState");
    // ignore: avoid_function_literals_in_foreach_calls
    listFilterState.forEach((f) {
      listFilterStateTemp.add(f);
    });
    notifyListeners();
  }

  void onCloseTimeDropDown() {
    print("${filterDateTemp.name} - ${filterDate.name}");
    filterDateTemp = FastPurchaseFilterDateTime.fromJson(filterDate.toJson());
    notifyListeners();
  }

  bool isInExistInFilterStateList(String state) {
    state = convertStateName(state);
    return listFilterStateTemp.contains(state);
  }

  bool isInExistInFilterDate(String text) {
    return filterDateTemp.name == text;
  }

  String convertStateName(String text) {
    if (text == S.current.paid) {
      return "paid";
    } else if (text == S.current.confirm) {
      return "open";
    } else if (text == S.current.cancel) {
      return "cancel";
    } else if (text == S.current.draft) {
      return "draft";
    }
//    switch (text) {
//      case "Đã thanh toán":
//        return "paid";
//      case "Xác nhận":
//        return "open";
//      case "Hủy bỏ":
//        return "cancel";
//      case "Nháp":
//        return "draft";
//    }
    return null;
  }

  String convertStateName2(String text) {
    switch (text) {
      case "paid":
        return S.current.paid;
      case "open":
        return S.current.confirm;
      case "cancel":
        return S.current.cancel;
      case "draft":
        return S.current.draft;
    }
    return null;
  }

  void onFilterDateTap(String name) {
    if (filterDateTemp.name == name) {
      filterDateTemp = FastPurchaseFilterDateTime();
      notifyListeners();
      return;
    }

    if (name == S.current.today) {
      filterDateTemp = FastPurchaseFilterDateTime(
          name: S.current.today,
          fromDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 0, 0, 0),
          toDate: DateTime(DateTime.now().year, DateTime.now().month,
              DateTime.now().day, 23, 59, 59, 99, 999));
    } else if (name == S.current.yesterday) {
      final DateTime toDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
        59,
        999,
      ).add(const Duration(days: -1));

      final DateTime fromDate =
          toDate.add(const Duration(days: -1)).add(const Duration(
                milliseconds: 1,
              ));
      filterDateTemp = FastPurchaseFilterDateTime(
          name: S.current.yesterday, fromDate: fromDate, toDate: toDate);
    } else if (name == S.current.filter_30daysAgo) {
      final DateTime toDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
        59,
        999,
      );

      final DateTime fromDate = toDate
          .add(const Duration(days: -30))
          .add(const Duration(milliseconds: 1));
      filterDateTemp = FastPurchaseFilterDateTime(
        name: S.current.filter_30daysAgo,
        toDate: toDate,
        fromDate: fromDate,
      );
    } else if (name == S.current.filter_7daysAgo) {
      final DateTime toDate = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        23,
        59,
        59,
        999,
      );

      final DateTime fromDate = toDate
          .add(const Duration(days: -7))
          .add(const Duration(milliseconds: 1));
      filterDateTemp = FastPurchaseFilterDateTime(
          name: S.current.filter_7daysAgo, toDate: toDate, fromDate: fromDate);
    }

//    switch (name) {
//      case "Hôm nay":
//        filterDateTemp = FastPurchaseFilterDateTime(
//            name: "Hôm nay",
//            fromDate: DateTime(DateTime.now().year, DateTime.now().month,
//                DateTime.now().day, 0, 0, 0),
//            toDate: DateTime(DateTime.now().year, DateTime.now().month,
//                DateTime.now().day, 23, 59, 59, 99, 999));
//        break;
//      case "Hôm qua":
//        DateTime toDate = DateTime(
//          DateTime.now().year,
//          DateTime.now().month,
//          DateTime.now().day,
//          23,
//          59,
//          59,
//          999,
//        ).add(const Duration(days: -1));
//
//        final DateTime fromDate =
//            toDate.add(const Duration(days: -1)).add(const Duration(
//                  milliseconds: 1,
//                ));
//        filterDateTemp = FastPurchaseFilterDateTime(
//            name: "Hôm qua", fromDate: fromDate, toDate: toDate);
//        break;
//      case "7 ngày gần nhất":
//        DateTime toDate = DateTime(
//          DateTime.now().year,
//          DateTime.now().month,
//          DateTime.now().day,
//          23,
//          59,
//          59,
//          999,
//        );
//
//        DateTime fromDate =
//            toDate.add(const Duration(days: -7)).add(Duration(milliseconds: 1));
//        filterDateTemp = FastPurchaseFilterDateTime(
//            name: "7 ngày gần nhất", toDate: toDate, fromDate: fromDate);
//        break;
//      case "30 ngày gần nhất":
//        DateTime toDate = DateTime(
//          DateTime.now().year,
//          DateTime.now().month,
//          DateTime.now().day,
//          23,
//          59,
//          59,
//          999,
//        );
//
//        final DateTime fromDate = toDate
//            .add(Duration(days: -30))
//            .add(const Duration(milliseconds: 1));
//        filterDateTemp = FastPurchaseFilterDateTime(
//          name: "30 ngày gần nhất",
//          toDate: toDate,
//          fromDate: fromDate,
//        );
//        break;
//    }
    notifyListeners();
  }

  void onPickDateFilter({DateTime fromDate, DateTime toDate}) {
    filterDateTemp = FastPurchaseFilterDateTime(
      name: S.current.chooseDate,
      fromDate: fromDate,
      toDate: toDate,
    );
    //loadData();
    notifyListeners();
  }

  bool isFilterByState() {
    return tempStateFilterName != null;
  }

  bool isFilterByTime() {
    return tempTimeFilterName != null;
  }

  void onEditModeItemTap(int id) {
    if (listPickedItem.contains(id)) {
      listPickedItem.remove(id);
    } else {
      listPickedItem.add(id);
    }
    notifyListeners();
  }

  void turnOffEditMode() {
    listPickedItem.clear();
    notifyListeners();
  }

  bool isExistInListEdit(int id) {
    return listPickedItem.contains(id);
  }

  Future<String> deletePickedItem() async {
    final String result = await _tposApi.unlinkPurchaseOrder(listPickedItem);
    listPickedItem.clear();
    isPickToDeleteMode = false;
    loadData();
    return result;

    /*Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        duration: Duration(milliseconds: 4000),
      ),
    );
    isPickToDeleteMode = false;
    loadData();*/
  }

  bool isLoadingGetDetailsFastPurchaseOrder = true;

  Future getDetailsFastPurchaseOrder() async {
    if (currentOrder != null) {
      isLoadingGetDetailsFastPurchaseOrder = true;
      notifyListeners();
      _tposApi.getDetailsPurchaseOrderById(currentOrder.id).then((result) {
        currentOrder = result;
        isLoadingGetDetailsFastPurchaseOrder = false;
        notifyListeners();
      });
    }
  }

  double getTotalCal(List<OrderLine> list) {
    double total = 0;
    // ignore: avoid_function_literals_in_foreach_calls
    list.forEach((f) {
      total = total + (f.priceUnit * f.productQty);
    });
    return total;
  }

  Future<String> doPaymentFPO(FastPurchaseOrderPayment item) async {
    final result = await _tposApi.doPaymentFastPurchaseOrder(item);
    if (result["value"] is int) {
      getDetailsFastPurchaseOrder();
      loadData();
      return "Success";
    } else if (result["message"] is String) {
      return "${result["message"]}";
    } else {
      throw Exception(S.current.error);
    }
  }

  Future<String> cancelOrder(int id) async {
    final result = await _tposApi.cancelFastPurchaseOrder([id]);
    if (result == "Success") {
      getDetailsFastPurchaseOrder();
      loadData();
    }
    return result;
  }

  Future<FastPurchaseOrder> actionOpenInvoice() async {
    //var fastPurchaseOrder = await _tposApi.actionInvoiceDraftFPO(currentOrder);
    final isSuccess = await _tposApi.actionInvoiceOpenFPO(currentOrder);
    if (isSuccess) {
      final details =
          await _tposApi.getDetailsPurchaseOrderById(currentOrder.id);
      loadData();
      return details;
    } else {
      throw Exception(S.current.error);
    }
  }

  Future<bool> editNoteInvoice(String text) async {
    currentOrder.note = text;
    return _tposApi.actionEditInvoice(currentOrder).then(
      (result) {
        if (result != null) {
          loadData();
          notifyListeners();
          return true;
        } else {
          throw Exception();
        }
      },
    ).catchError(
      (error) {
        throw Exception(error.toString().replaceAll("Exception:", ""));
      },
    );
  }

  Future<FastPurchaseOrder> createRefundOrder() async {
    ///input: id của hóa đơn nhập hàng
    final idInvoice = await _tposApi.createRefundOrder(currentOrder.id);
    final FastPurchaseOrder refundOrder =
        await _tposApi.getDetailsPurchaseOrderById(idInvoice);
    if (refundOrder != null) {
      currentOrder = refundOrder;
      return refundOrder;
    } else {
      throw Exception(S.current.failed);
    }
  }

  void onChangeSearchText(String text) {
    listForDisplay = list.where(
      (item) {
        return (item.number ?? "").toLowerCase().contains(text.toLowerCase()) ||
            (item.partnerDisplayName ?? "")
                .toLowerCase()
                .contains(text.toLowerCase());
      },
    ).toList();
    notifyListeners();
  }
}

///desc,asc
///sort:  DateInvoice,AmountTotal,Number
class FastPurchaseOrderSort {
  FastPurchaseOrderSort({this.dir = "desc", this.field = "DateInvoice"});
  String dir;
  String field;
}

class FastPurchaseFilterDateTime {
  FastPurchaseFilterDateTime({this.fromDate, this.toDate, this.name});
  FastPurchaseFilterDateTime.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    name = json['name'];
  }
  DateTime fromDate;
  DateTime toDate;
  String name;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fromDate'] = fromDate;
    data['toDate'] = toDate;
    data['name'] = name;
    return data;
  }
}
