import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_panel.dart';
import 'package:tpos_mobile/app_core/template_ui/empty_data_widget.dart';
import 'package:tpos_mobile/app_core/ui_base/view_base.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/uis/sale_quotation_add_edit_page.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/uis/sale_quotation_info_page.dart';
import 'package:tpos_mobile/feature_group/sale_quotation/viewmodel/sale_quotation_list_viewmodel.dart';

import 'package:tpos_mobile/locator.dart';
import 'package:tpos_mobile/services/dialog_service.dart';
import 'package:tpos_mobile/src/tpos_apis/models/sale_quotation.dart';

class SaleQuotationListPage extends StatefulWidget {
  @override
  _SaleQuotationListPageState createState() => _SaleQuotationListPageState();
}

class _SaleQuotationListPageState extends State<SaleQuotationListPage> {
  var _vm = locator<SaleQuotationListViewModel>();
  TextEditingController _searchController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _vm.getSaleQuotations();
  }

  Widget _buildSearch() {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(24)),
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 12,
          ),
          Icon(
            Icons.search,
            color: Color(0xFF28A745),
          ),
          Expanded(
            child: Center(
              child: Container(
                  height: 35,
                  margin: EdgeInsets.only(left: 4),
                  child: Center(
                    child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          if (value == "" || value.length == 1) {
                            setState(() {});
                          }
                          _vm.searchOrderCommand(value);
                        },
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            isDense: true,
                            hintText: "Tìm kiếm",
                            border: InputBorder.none)),
                  )),
            ),
          ),
          Visibility(
            visible: _searchController.text != "",
            child: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _searchController.text = "";
                });
                _vm.searchOrderCommand("");
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewBase<SaleQuotationListViewModel>(
        model: _vm,
        builder: (context, model, _) {
          return Scaffold(
            backgroundColor: Colors.grey[200],
            key: scaffoldKey,
            appBar: AppBar(
              title: _vm.isSearch
                  ? _buildSearch()
                  : Text('Danh sách phiếu báo giá'),
              actions: <Widget>[
                Visibility(
                  visible: _vm.saleQuotationsSelected.isEmpty,
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      _vm.isSearch = !_vm.isSearch;
                      _searchController.text = "";
                    },
                  ),
                ),
                Visibility(
                  visible: _vm.saleQuotationsSelected.length == 0,
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SaleQuotationAddEditPage()),
                      ).then((value) {
                        if (value != null) {
                          if (value) {
                            _vm.getSaleQuotations();
                          }
                        }
                      });
                    },
                  ),
                ),
                Visibility(
                  visible: _vm.saleQuotationsSelected.isNotEmpty,
                  child: InkWell(
                    onTap: () {
                      _vm.deleteMultiSaleQuotation();
                    },
                    child: Row(
                      children: <Widget>[
                        const Text("Xóa"),
                        Icon(Icons.delete_forever),
                        const SizedBox(
                          width: 12,
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _vm.saleQuotationsSelected.isEmpty,
                  child: InkWell(
                    onTap: () {
                      scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Row(
                      children: <Widget>[
                        Text("Lọc"),
                        Badge(
                          padding: EdgeInsets.all(4),
                          badgeColor: Colors.redAccent,
                          badgeContent: Text(
                            "${_vm.countFilter()}",
                            style: const TextStyle(color: Colors.white),
                          ),
                          child: Icon(
                            Icons.filter_list,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 14,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _vm.getSaleQuotations();
                },
                child: Column(
                  children: <Widget>[
                    Visibility(
                        visible: _vm.saleQuotationsSelected.isNotEmpty,
                        child: _buildFilter()),
                    Expanded(
                      child: _vm.saleQuotations.length == 0
                          ? EmptyData()
                          : ListView.builder(
                              itemCount: _vm.saleQuotations.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _showItem(
                                    _vm.saleQuotations[index], index);
                              }),
                    ),
                  ],
                ),
              ),
            ),
            endDrawer: _buildFilterPanel(),
          );
        });
  }

  Widget _buildFilter() {
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(blurRadius: 1, offset: Offset(0, 1), color: Colors.grey[300])
      ]),
      child: InkWell(
        onTap: () {},
        child: Row(
          children: <Widget>[
            Visibility(
              visible: _vm.saleQuotationsSelected.isNotEmpty,
              child: IconButton(
                icon: Icon(
                  Icons.clear,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  _vm.saleQuotationsSelected.clear();

                  _vm.setUnselected(true);
                },
              ),
            ),
            Expanded(
                child: Visibility(
              visible: _vm.saleQuotationsSelected.isNotEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    "Đã chọn:    ${_vm.saleQuotationsSelected.length} phiếu",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )),
            SizedBox(
              width: 18,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPanel() {
    return AppFilterDrawerContainer(
      onRefresh: () {
        _vm.resetFilter();
      },
      closeWhenConfirm: true,
      onApply: () {
        _vm.handleFilter();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AppFilterDateTime(
            isSelected: _vm.isFilterByDate,
            initDateRange: _vm.filterDateRange,
            onSelectChange: (value) {
              _vm.isFilterByDate = value;
            },
            toDate: _vm.filterToDate,
            fromDate: _vm.filterFromDate,
            dateRangeChanged: (value) {
              _vm.filterDateRange = value;
            },
            onFromDateChanged: (value) {
              _vm.filterFromDate = value;
            },
            onToDateChanged: (value) {
              _vm.filterToDate = value;
            },
          ),
          AppFilterPanel(
            isEnable: true,
            isSelected: _vm.isFilterByStatus,
            onSelectedChange: (bool value) => _vm.isFilterByStatus = value,
            title: Text("Lọc theo trạng thái"),
            children: <Widget>[
              Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Wrap(
                      runSpacing: 0,
                      runAlignment: WrapAlignment.start,
                      spacing: 5,
                      children: _vm.filterStatusList
                              ?.map(
                                (f) => FilterChip(
                                  label: Text(
                                    f.description,
                                    style: TextStyle(
                                        color: f.isSelected
                                            ? Colors.white
                                            : Colors.grey),
                                  ),
                                  onSelected: (value) {
                                    setState(() {
                                      f.isSelected = value;
                                    });
                                  },
                                  selected: f.isSelected,
                                  selectedColor: f.textColor,
                                ),
                              )
                              ?.toList() ??
                          List<Widget>(),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _showItem(SaleQuotation item, int index) {
    if (_vm.isUnselect) {
      item.isSelect = false;
    }
    return item == tempSaleQuotation
        ? _vm.isLoadMore
            ? Center(
                child: SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Center(
                child: Container(
                  margin:
                      EdgeInsets.only(top: 12, left: 12, right: 12, bottom: 8),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(3)),
                  height: 45,
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        _vm.isLoadMore = true;
                      });
                      _vm.handleItemCreated(index);
                    },
                    color: Colors.blueGrey,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Tải tiếp",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(
                            width: 12,
                          ),
                          Icon(
                            Icons.save_alt,
                            color: Colors.white,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
        : Center(
            child: Container(
              padding: EdgeInsets.only(top: 12, left: 12, right: 12),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: item.isSelect
                              ? Colors.green
                              : Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      color: Colors.white),
                  child: Row(
                    children: <Widget>[
                      Visibility(
                          visible: item.isSelect,
                          child: Checkbox(
                              activeColor: Colors.green,
                              value: item.isSelect,
                              onChanged: (bool value) {
                                _vm.selectQuotation(
                                    saleQuotation: item,
                                    index: index,
                                    value: value);
                              })),
                      Visibility(
                        visible: !item.isSelect,
                        child: SizedBox(
                          width: 12,
                        ),
                      ),
                      Expanded(
                          child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        onLongPress: () {
                          _vm.selectQuotation(
                              saleQuotation: item, index: index, value: true);
                        },
                        onTap: () async {
                          if (item.isSelect) {
                            _vm.selectQuotation(
                                saleQuotation: item,
                                index: index,
                                value: false);
                          } else if (!item.isSelect &&
                              _vm.saleQuotationsSelected.isNotEmpty) {
                            _vm.selectQuotation(
                                saleQuotation: item, index: index, value: true);
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaleQuotationInfoPage(
                                        id: item.id,
                                        callback: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _vm.saleQuotations[index] = value;
                                            });
                                          }
                                        },
                                        saleQuotation: item,
                                      )),
                            );
                          }
                        },
                        title: Row(
                          children: <Widget>[
                            Expanded(
                              child: AutoSizeText(
                                "${item.name ?? ""}",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: item.state == "draft"
                                      ? Colors.grey
                                      : Colors.green,
                                ),
                                maxLines: 1,
                              ),
                            ),
                            Text(
                                "${vietnameseCurrencyFormat(item.amountTotal)}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600)),
                            InkWell(
                              onTap: () {
                                _buildBottomSheetOption(context, item, index);
                              },
                              child: Container(
                                width: 40,
                                height: 35,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        subtitle: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.people,
                                  size: 17,
                                  color: item.state == "draft"
                                      ? Colors.grey
                                      : Colors.green.withOpacity(0.6),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    "${item.partner}",
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.star_border,
                                  size: 17,
                                  color: item.state == "draft"
                                      ? Colors.grey
                                      : Colors.green.withOpacity(0.6),
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    "${item.showInvoiceStatus}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Divider(),
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.only(right: 6, left: 1.5),
                                  decoration: BoxDecoration(
                                      color: item.state == "draft"
                                          ? Colors.grey.withOpacity(0.5)
                                          : Colors.green.withOpacity(0.6),
                                      shape: BoxShape.circle),
                                ),
                                Expanded(
                                  child: Text(
                                    "${item.showState ?? ""}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: item.state == "draft"
                                          ? Colors.grey
                                          : Colors.green,
                                    ),
                                  ),
                                ),
//                                      Text(
//                                        "${item.showInvoiceStatus}",
//                                        textAlign: TextAlign.right,
//                                        style: TextStyle(
//                                            fontSize: 15,
//                                            color: Colors.grey[700],
//                                            fontWeight: FontWeight.w500),
//                                      ),
                                Icon(
                                  Icons.date_range,
                                  size: 16,
                                  color: item.state == "draft"
                                      ? Colors.grey
                                      : Colors.green.withOpacity(0.6),
                                ),
                                SizedBox(
                                  width: 4,
                                ),

                                Text(
                                  "${item.dateQuotation != null ? DateFormat("dd-MM-yyyy HH:mm").format(DateTime.fromMicrosecondsSinceEpoch(int.parse(item.dateQuotation.substring(6, item.dateQuotation.length - 2)) * 1000).toLocal()) : ""}",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      )),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  )),
            ),
          );
  }

  void _buildBottomSheetOption(
      BuildContext contextBuild, SaleQuotation item, int index) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(18),
                    topLeft: Radius.circular(18))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 6,
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                  title: Text("Chọn phiếu"),
                  onTap: () async {
                    Navigator.pop(contextBuild);
                    _vm.selectQuotation(
                        saleQuotation: item, index: index, value: true);
                  },
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                ListTile(
                  leading: Icon(
                    Icons.explicit,
                    color: Colors.green,
                  ),
                  title: Text("Xuất Excel"),
                  onTap: () async {
                    Navigator.pop(contextBuild);
                    _vm.exportExcel(item.id.toString(), contextBuild);
                  },
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                ListTile(
                  leading: Icon(
                    Icons.content_copy,
                  ),
                  title: Text("Copy phiếu báo giá"),
                  onTap: () async {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaleQuotationAddEditPage(
                                isCopy: true,
                                quotationId: item.id,
                              )),
                    ).then((value) {
                      if (value != null) {
                        if (value) {
                          _vm.getSaleQuotations();
                        }
                      }
                    });
                  },
                ),
                Divider(
                  height: 0.5,
                  color: Colors.grey[300],
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  title: Text("Xóa phiếu báo giá"),
                  onTap: () async {
                    Navigator.pop(context);
                    var dialogResult = await showQuestion(
                        context: context,
                        title: "Xác nhận xóa",
                        message: "Bạn có muốn xóa phiếu thu");
                    if (dialogResult == DialogResultType.YES) {
                      await _vm.deleteSaleQuotation(item.id, item);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }
}
