import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class ReportStockState {}

/// Chạy loading khi load báo cáo xuất nhập tồn
class ReportStockLoading extends ReportStockState {}

/// Chạy loading khi thực hiện load more báo cáo xuất nhập tồn
class ReportStockLoadMoreLoading extends ReportStockState {}

/// Trả về dữ liệu khi thực hiện load thành công
class ReportStockLoadSuccess extends ReportStockState {
  ReportStockLoadSuccess(
      {this.reportStock, this.isFilter = false, this.stockFilter});
  final ReportStock reportStock;
  final bool isFilter;
  final StockFilter stockFilter;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class ReportStockLoadFailure extends ReportStockState {
  ReportStockLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
