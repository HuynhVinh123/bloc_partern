import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class ReportStockIncurredEvent {}

/// Chạy loading khi load trang tổng quan
class ReportStockIncurredLoaded extends ReportStockIncurredEvent {
  ReportStockIncurredLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

class ReportStockIncurredFilterSaved extends ReportStockIncurredEvent{
  ReportStockIncurredFilterSaved({this.stockFilter,this.limit,this.skip});
  final StockFilter stockFilter;
  final int limit;
  final int skip;
}

class ReportStockIncurredLocalFilterSaved  extends ReportStockIncurredEvent{
  ReportStockIncurredLocalFilterSaved({this.stockFilter});
  final StockFilter stockFilter;
}

/// Event load more danh sách trên trang tổng quan
class ReportStockIncurredLoadMoreLoaded extends ReportStockIncurredEvent {
  ReportStockIncurredLoadMoreLoaded({this.skip, this.limit, this.reportStockIncurred});
  final int limit;
  final int skip;
  final ReportStock reportStockIncurred;
}

