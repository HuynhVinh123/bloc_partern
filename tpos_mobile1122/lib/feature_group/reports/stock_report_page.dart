import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/template_ui/app_appbar_search.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_bool.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_datetime.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_drawer.dart';
import 'package:tpos_mobile/app_core/template_ui/app_filter_object.dart';

import 'package:tpos_mobile/app_core/ui_base/ui_base.dart';
import 'package:tpos_mobile/feature_group/category/stock_ware_house_select_page.dart';
import 'package:tpos_mobile/feature_group/reports/viewmodels/inventory_report_viewmodel.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/product_category_page.dart';

import 'package:tpos_mobile/src/tpos_apis/models/stock_report_result.dart';

class StockReportPage extends StatefulWidget {
  @override
  _StockReportPageState createState() => _StockReportPageState();
}

class _StockReportPageState extends State<StockReportPage> {
  var _vm = InventoryReportViewModel();
  bool _isSearchVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _vm.initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<InventoryReportViewModel>(
      model: _vm,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: _isSearchVisible
              ? AppAppBarSearchTitle(
                  controller: TextEditingController(),
                  onSearch: (text) {
                    _vm.keywordSink.add(text);
                  },
                )
              : Text("Xuất nhập tồn"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchVisible = !_isSearchVisible;
                });
              },
            ),
          ],
        ),
        body: UIViewModelBase(viewModel: _vm, child: _buildBody()),
        endDrawer: ScopedModelDescendant<InventoryReportViewModel>(
          builder: (context, child, model) => _buildFilterDrawer(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        ScopedModelDescendant<InventoryReportViewModel>(
          builder: (_, __, ___) => AppFilterListHeader(
            children: [
              AppFilterListHeaderItem(
                hint: "Chọn ngày lọc",
                value: _vm.isFilterByDate ? _vm.filterByDateString : null,
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
              AppFilterListHeaderItem(
                hint: "Kho hàng",
                value: _vm.isFilterByStock ? _vm.selectedWareHouse?.name : null,
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
              AppFilterListHeaderItem(
                hint: "Nhóm sản phẩm",
                value: _vm.isFilterByStock
                    ? _vm.selectedProductCategory?.name
                    : null,
                onPressed: () {
                  _scaffoldKey.currentState.openEndDrawer();
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildHeader(),
                    _buildListReport(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return ScopedModelDescendant<InventoryReportViewModel>(
      builder: (context, child, model) => Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
        child: Container(
          height: 66,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: StockReportHeaderItemView(
                    title: "Đầu kỳ", value: _vm.beginQuantity),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: StockReportHeaderItemView(
                  title: "Nhập trong kỳ",
                  value: _vm.importQuantity,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: StockReportHeaderItemView(
                  title: "Xuất trong kỳ",
                  value: _vm.exportQuantity,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: StockReportHeaderItemView(
                  title: "Cuối kỳ",
                  value: _vm.endQuantity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListReport() {
    return ScopedModelDescendant<InventoryReportViewModel>(
      builder: (_, __, ___) => Container(
        color: Colors.white,
        child: ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                StockReportDataItemView(data: _vm.stockRepotDatasResult[index]),
            separatorBuilder: (context, index) => Divider(
                  height: 1,
                  indent: 50,
                ),
            itemCount: _vm.stockRepotDatasResult?.length ?? 0),
      ),
    );
  }

  /// Build widget điều kiện lọc
  Widget _buildFilterDrawer() {
    return AppFilterDrawerContainer(
      onRefresh: _vm.resetFilter, // Thiết lập lại
      closeWhenConfirm: true,
      onApply: _vm.applyFilter, //Áp dụng
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Lọc theo thời gian
            // Lọc theo thời gian
            AppFilterDateTime(
              isSelected: _vm.isFilterByDate,
              fromDate: _vm.fromDate,
              toDate: _vm.toDate,
              initDateRange: _vm.filterDateRange,
              onFromDateChanged: (value) {
                _vm.fromDate = value;
              },
              onToDateChanged: (value) {
                _vm.toDate = value;
              },
              onSelectChange: (value) {
                setState(() {
                  _vm.isFilterByDate = value;
                });
              },
              dateRangeChanged: (value) {
                _vm.filterDateRange = value;
              },
            ),
            // Lọc theo kho hàng
            AppFilterObject(
              title: Text("Lọc theo kho"),
              isSelected: _vm.isFilterByStock,
              content: _vm.selectedWareHouse?.name,
              hint: "Chọn kho",
              onSelect: () async {
                var selected = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StockWareHouseSelectPage(),
                  ),
                );

                _vm.selectedWareHouse = selected;
              },
              onSelectChange: (isSelected) {
                _vm.isFilterByStock = isSelected;
              },
            ),
            // Lọc theo nhóm sản phẩm
            AppFilterObject(
              title: Text("Lọc theo nhóm sản phẩm"),
              isSelected: _vm.isFilterByProductGroup,
              content: _vm.selectedProductCategory?.name,
              hint: "Chọn nhóm sảm phẩm",
              onSelect: () async {
                var productCategory = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductCategoryPage(),
                  ),
                );

                if (productCategory != null)
                  _vm.selectedProductCategory = productCategory ?? null;
              },
              onSelectChange: _vm.setIsFilterByProductGroup,
            ),
            AppFilterBool(
              title: Text("Bao gồm cả phiếu hủy"),
              value: _vm.isIncludeCancel,
              onSelectedChange: _vm.setIsIncludeCancel,
            ),
            AppFilterBool(
              title: Text("Bao gồm cả trả hàng"),
              value: _vm.isIncludeRefund,
              onSelectedChange: _vm.setIsIncludeRefund,
            ),
          ],
        ),
      ),
    );
  }
}

class StockReportHeaderItemView extends StatelessWidget {
  final String title;
  final double value;
  final Key key;
  final TextAlign align;
  StockReportHeaderItemView(
      {this.title, this.value, this.key, this.align = TextAlign.center})
      : super(key: key);
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.grey.shade100,
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              title ?? "",
              style: TextStyle(color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            AutoSizeText(
              "${NumberFormat("###,###,###.##").format(value ?? 0)}",
              textAlign: align,
              maxFontSize: 17,
              minFontSize: 10,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 22,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class StockReportDataItemView extends StatelessWidget {
  final StockReportData data;
  final Key key;
  StockReportDataItemView({this.data, this.key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("${data.productName} (${data.productUOMName})"),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "${data.begin}",
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "${data.import}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.green),
            ),
          ),
          Expanded(
            child: Text(
              "${data.export}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.deepOrange),
            ),
          ),
          Expanded(
            child: Text(
              "${data.end}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
