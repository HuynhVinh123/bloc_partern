import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class ReportStockIncurredState {}

/// Chạy loading khi load báo cáo
class ReportStockIncurredLoading extends ReportStockIncurredState {}

/// Chạy loading khi thực hiện load more sản phẩm trong báo cáo
class ReportStockIncurredLoadMoreLoading extends ReportStockIncurredState {}

/// Trả về dữ liệu khi thực hiện load filter thành công
class ReportStockIncurredLoadSuccess extends ReportStockIncurredState {
  ReportStockIncurredLoadSuccess(
      {this.reportStockIncurred, this.isFilter = false, this.stockFilter});
  final ReportStock reportStockIncurred;
  final bool isFilter;
  final StockFilter stockFilter;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class ReportStockIncurredLoadFailure extends ReportStockIncurredState {
  ReportStockIncurredLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
