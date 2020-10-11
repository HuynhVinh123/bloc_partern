import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class ReportStockEvent {}

/// Chạy loading khi load trang tổng quan
class ReportStockLoaded extends ReportStockEvent {
  ReportStockLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

/// Event load more danh sách trên trang tổng quan
class ReportStockLoadMoreLoaded extends ReportStockEvent {
  ReportStockLoadMoreLoaded({this.skip, this.limit, this.reportStock});
  final int limit;
  final int skip;
  final ReportStock reportStock;
}

/// Chạy loading khi load trang tổng quan
class ReportStockExtLoaded extends ReportStockEvent {
  ReportStockExtLoaded({this.skip, this.limit});
  final int limit;
  final int skip;
}

class ReportStockFilterSaved extends ReportStockEvent{
  ReportStockFilterSaved({this.stockFilter,this.limit,this.skip});
  final StockFilter stockFilter;
  final int limit;
  final int skip;
}

class ReportStockLocalFilterSaved extends ReportStockEvent{
  ReportStockLocalFilterSaved({this.stockFilter});
  final StockFilter stockFilter;
}

/// Event load more danh sách trên trang tổng quan
class ReportStockExtLoadMoreLoaded extends ReportStockEvent {
  ReportStockExtLoadMoreLoaded({this.skip, this.limit, this.reportStock});
  final int limit;
  final int skip;
  final ReportStock reportStock;
}
