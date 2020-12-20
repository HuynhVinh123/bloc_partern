import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class ReportStockEvent {}

/// Event load báo cáo xuất nhập tồn
class ReportStockLoaded extends ReportStockEvent {
  ReportStockLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event load more danh sách trên báo cáo xuất nhập tồn
class ReportStockLoadMoreLoaded extends ReportStockEvent {
  ReportStockLoadMoreLoaded({this.skip, this.limit, this.reportStock});
  final int limit;
  final int skip;
  final ReportStock reportStock;
}

/// Save filter và get báo cáo xuất nhập tồn
class ReportStockFilterSaved extends ReportStockEvent {
  ReportStockFilterSaved(
      {this.stockFilter, this.limit, this.skip, this.isFilter = false});
  final StockFilter stockFilter;
  final int limit;
  final int skip;
  final bool isFilter;
}

/// Event lưu filter
class ReportStockLocalFilterSaved extends ReportStockEvent {
  ReportStockLocalFilterSaved({this.stockFilter});
  final StockFilter stockFilter;
}
