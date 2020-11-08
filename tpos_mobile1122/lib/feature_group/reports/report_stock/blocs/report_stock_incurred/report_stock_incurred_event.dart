import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class ReportStockIncurredEvent {}

/// Event load báo cáo xuất nhập tồn phát sinh
class ReportStockIncurredLoaded extends ReportStockIncurredEvent {
  ReportStockIncurredLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event lưu và load lại báo cáo
class ReportStockIncurredFilterSaved extends ReportStockIncurredEvent {
  ReportStockIncurredFilterSaved(
      {this.stockFilter, this.limit, this.skip, this.isFilter});
  final StockFilter stockFilter;
  final int limit;
  final int skip;
  final bool isFilter;
}

/// Event lưu filter
class ReportStockIncurredLocalFilterSaved extends ReportStockIncurredEvent {
  ReportStockIncurredLocalFilterSaved({this.stockFilter});
  final StockFilter stockFilter;
}

/// Event loadmore báo cáo xuất nhập tồn phát sinh
class ReportStockIncurredLoadMoreLoaded extends ReportStockIncurredEvent {
  ReportStockIncurredLoadMoreLoaded(
      {this.skip, this.limit, this.reportStockIncurred});
  final int limit;
  final int skip;
  final ReportStock reportStockIncurred;
}
