import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/template_ui/reload_list_page.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/reports/custom_date_time.dart';
import 'package:tpos_mobile/feature_group/reports/report_order/ui/company_of_user_list_page.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/business_result_viewmodel.dart';
import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/src/tpos_apis/models/company_of_user.dart';
import 'package:tpos_mobile/widgets/dialog/alert_type.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

import '../../app.dart';
import 'business_result.dart';

class BusinessResultPage extends StatefulWidget {
  const BusinessResultPage({Key key}) : super(key: key);

  @override
  _BusinessResultPageState createState() => _BusinessResultPageState();
}

class _BusinessResultPageState extends State<BusinessResultPage> {
  final _viewModel = locator<BusinessResultViewModel>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget buildAppBar() {
    //Báo cáo kết quả kinh doanh
    return AppBar(
      title: Text(S.current.menu_businessReport),
    );
  }

  Key refreshIndicatorKey = const Key("refreshIndicator");

  int sharedValue = 0;
  final Map<int, Widget> tabTitles = <int, Widget>{
    0:
        //Theo tháng
        Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFF28A745),
          ),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6), bottomLeft: Radius.circular(6))),
      child: Center(
        child: Text(
          S.current.businessReport_monthly,
          style: const TextStyle(color: Color(0xFF28A745)),
        ),
      ),
    ),
    1: Container(
      padding: const EdgeInsets.all(8.0),
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDFE5E9)),
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6), bottomRight: Radius.circular(6))),
      // Theo năm
      child: Center(
        child: Text(
          S.current.businessReport_byYear,
          style: const TextStyle(color: Color(0xFF858F9B)),
        ),
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return ViewBase<BusinessResultViewModel>(
      model: _viewModel,
      builder: (context, model, sizingInformation) => Scaffold(
        backgroundColor: const Color(0xFFEBEDEF),
        key: _scaffoldKey,
        appBar: buildAppBar(),
        body: ReloadListPage(
          vm: _viewModel,
          onPressed: () {
            _viewModel.loadBusinessResult();
          },
          child: _viewModel.businessResult != null &&
                  _viewModel.businessResult.datas.isNotEmpty
              ? _showBusinessResult()
              : EmptyData(
                  onPressed: () {
                    _viewModel.loadBusinessResult();
                  },
                ),
        ),
      ),
    );
  }

  Widget _showDateFilter() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16),
      child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 65,
            child: Row(
              children: <Widget>[
                const SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Từ năm  Từ tháng
                      Text(
                          _viewModel.selectedTypeReport == 1
                              ? "${S.current.businessReport_fromYear}: "
                              : "${S.current.businessReport_fromMonth}: ",
                          style: const TextStyle(
                              color: Color(0xFF929DAA), fontSize: 14)),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 34,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE9EDF2)),
                        ),
                        child: FlatButton(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _viewModel.filterFromDate != null
                                        ? _viewModel.selectedTypeReport == 0
                                            ? DateFormat("MM/yyyy").format(
                                                _viewModel.filterFromDate)
                                            : DateFormat("yyyy").format(
                                                _viewModel.filterFromDate)
                                        : "",
                                  ),
                                ),
                                const Icon(
                                  Icons.date_range,
                                  color: Color(0xFF91D2A0),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () async {
                              _showDatePicker(
                                  filterFromDate: _viewModel.filterFromDate);
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Tới năm  Tới tháng
                      Text(
                        _viewModel.selectedTypeReport == 1
                            ? "${S.current.businessReport_toYear}: "
                            : "${S.current.businessReport_toMonth}: ",
                        style: const TextStyle(
                            color: Color(0xFF929DAA), fontSize: 14),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Container(
                        height: 34,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE9EDF2)),
                        ),
                        child: FlatButton(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    // ignore: unnecessary_string_interpolations
                                    "${_viewModel.filterToDate != null ? _viewModel.selectedTypeReport == 0 ? DateFormat("MM/yyyy").format(_viewModel.filterToDate) : DateFormat("yyyy").format(_viewModel.filterToDate) : ""}",
                                  ),
                                ),
                                const Icon(
                                  Icons.date_range,
                                  color: Color(0xFF91D2A0),
                                  size: 18,
                                )
                              ],
                            ),
                            onPressed: () async {
                              _showDatePicker(
                                  filterToDate: _viewModel.filterToDate);
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () async {
              final CompanyOfUser result = await Navigator.push(context,
                  MaterialPageRoute(builder: (context) {
                return CompanyOfUserListPage();
              }));
              if (result != null) {
                _viewModel.companyOfUser = result;
              }
            },
            child: Container(
              height: 36,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFFE9EDF2)),
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Text(_viewModel.companyOfUser != null
                        ? _viewModel.companyOfUser?.text
                        // Công ty
                        : S.current.company),
                  ),
                  Visibility(
                    visible: _viewModel.companyOfUser != null,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                      onPressed: () {
                        _viewModel.companyOfUser = null;
                      },
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: MaterialButton(
              elevation: 0,
              height: 36,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () {
                onApply();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.check,
                    color: Color(0xFF28A745),
                    size: 19,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  //Áp dụng
                  Text(
                    S.current.apply,
                    style:
                        const TextStyle(color: Color(0xFF28A745), fontSize: 15),
                  ),
                ],
              ),
              color: Colors.white,
              shape: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE9EDF2))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showBusinessResult() {
    const style = TextStyle(fontSize: 15);
    final Map<int, Widget> icons = <int, Widget>{
      0: _showDateFilter(),
      1: _showDateFilter(),
    };
    return RefreshIndicator(
      key: refreshIndicatorKey,
      onRefresh: () async {
        _viewModel.loadBusinessResult();
      },
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: CupertinoSegmentedControl<int>(
                  children: tabTitles,
                  selectedColor: const Color(0xFFF2FCF5),
                  borderColor: Colors.transparent,
                  onValueChanged: (int value) {
                    if (value == 0) {
                      _viewModel.positionFilter = 2;
                      tabTitles[0] =
                          // Theo tháng
                          Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF28A745)),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6))),
                        child: Center(
                          child: Text(
                            S.current.businessReport_monthly,
                            style: const TextStyle(color: Color(0xFF28A745)),
                          ),
                        ),
                      );
                      tabTitles[1] =
                          // Theo năm
                          Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDFE5E9)),
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomRight: Radius.circular(6))),
                        child: Center(
                          child: Text(
                            S.current.businessReport_byYear,
                            style: const TextStyle(color: Color(0xFF858F9B)),
                          ),
                        ),
                      );
                    } else if (value == 1) {
                      _viewModel.positionFilter = 3;
                      tabTitles[value] = Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFF28A745)),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(6),
                                  bottomRight: Radius.circular(6))),
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: Text(
                              S.current.businessReport_byYear,
                              style: const TextStyle(color: Color(0xFF28A745)),
                            ),
                          ));
                      tabTitles[0] = Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFDFE5E9)),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                bottomLeft: Radius.circular(6))),
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        height: double.infinity,
                        //Theo tháng
                        child: Center(
                          child: Text(
                            S.current.businessReport_monthly,
                            style: const TextStyle(color: Color(0xFF858F9B)),
                          ),
                        ),
                      );
                    }

                    _viewModel.selectedTypeReport = value;
                    _viewModel.setCommandTypeReport(value);
                    _viewModel.filterFromDate = DateTime(
                        _viewModel.filterFromDate.year,
                        DateTime.now().month,
                        DateTime.now().day);
                    _viewModel.filterToDate = DateTime(
                        _viewModel.filterToDate.year,
                        DateTime.now().month,
                        DateTime.now().day);
                  },
                  groupValue: _viewModel.selectedTypeReport,
                ),
              ),
            ),
            icons[_viewModel.selectedTypeReport],
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: DataTable(
                        dividerThickness: 0,
                        horizontalMargin: 0,
                        sortColumnIndex: _viewModel.sortColumnIndex,
                        sortAscending: _viewModel.sortAscending,
                        columns: <DataColumn>[
                          //LOẠI
                          DataColumn(
                            label: Text(S.current.type.toUpperCase(),
                                style: style.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2C333A))),
                            onSort: (int columnIndex, bool ascending) =>
                                _viewModel.sortDetail<String>(
                                    (Datas d) => d.name,
                                    columnIndex,
                                    ascending),
                          ),
                          //GIÁ TRỊ
                          DataColumn(
                            numeric: true,
                            label: Text(
                                S.current.businessReport_value.toUpperCase(),
                                style: style.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2C333A))),
                            onSort: (int columnIndex, bool ascending) =>
                                _viewModel.sortDetail<num>((Datas d) => d.value,
                                    columnIndex, ascending),
                          ),
                        ],
                        rows: _viewModel.businessResult?.datas
                                ?.map(
                                  (itemRow) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          itemRow.name ?? '',
                                          style: style,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      DataCell(
                                          Text(
                                            '${itemRow.sign == 1 ? "+" : "-"} ${vietnameseCurrencyFormat(
                                              itemRow.value,
                                            )}',
                                            style: style.copyWith(
                                              color: itemRow.sign == 1
                                                  ? const Color(0xFF28A745)
                                                  : Colors.red,
                                            ),
                                          ),
                                          onTap: () {}),
                                    ],
                                  ),
                                )
                                ?.toList() ??
                            [],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.only(
                            right: 8, top: 8, bottom: 8, left: 10),
                        margin:
                            const EdgeInsets.only(right: 8, top: 12, bottom: 8),
                        // width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: const Color(0xFFF8F9FB)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            //Tổng
                            Flexible(
                              child: Text('${S.current.totalAmount}:',
                                  style: style.copyWith(
                                      color: const Color(0xFF5A6271),
                                      fontSize: 16)),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(vietnameseCurrencyFormat(_viewModel.sum),
                                style: style.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2C333A),
                                    fontSize: 16))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }

  void _showDatePicker({DateTime filterFromDate, DateTime filterToDate}) {
    DatePickerCustom.showDatePicker(context, onConfirm: (dateTime) async {
      _viewModel.setDateFilter(dateTime,
          fromDate: filterFromDate, toDate: filterToDate);
    },
        isShowYear: _viewModel.selectedTypeReport != 0,
        maxTime: DateTime(2100, 1, 1),
        minTime: DateTime(1900, 1, 1),
        currentTime: filterFromDate ?? filterToDate ?? DateTime.now());
  }

  /// Thực hiện filter ngày r áp dụng
  void onApply() {
    if (_viewModel.selectedTypeReport == 1) {
      print(_viewModel.filterToDate);
      print(_viewModel.filterFromDate);
      print(_viewModel.filterToDate.compareTo(_viewModel.filterFromDate));

      if (_viewModel.filterToDate.compareTo(_viewModel.filterFromDate) == 1 ||
          _viewModel.filterToDate.compareTo(_viewModel.filterFromDate) == 0) {
        _viewModel.loadBusinessResult();
      } else {
        App.showDefaultDialog(
            title: S.current.invalidData,
            content:
                '\'${S.current.businessReport_toYear}\' ${S.current.notify_ErrorSelectDate} \'${S.current.businessReport_fromYear}\'',
            context: context,
            type: AlertDialogType.warning);
      }
    } else {
      if (_viewModel.filterToDate.compareTo(_viewModel.filterFromDate) == 1 ||
          _viewModel.filterToDate.compareTo(_viewModel.filterFromDate) == 0) {
        _viewModel.loadBusinessResult();
      } else {
        App.showDefaultDialog(
            title: S.current.invalidData,
            content:
                '\'${S.current.businessReport_toMonth}\' ${S.current.notify_ErrorSelectDate} \'${S.current.businessReport_fromMonth}\'',
            context: context,
            type: AlertDialogType.warning);
      }
    }
  }

  @override
  void initState() {
    _viewModel.initCommand();
    super.initState();
  }
}
