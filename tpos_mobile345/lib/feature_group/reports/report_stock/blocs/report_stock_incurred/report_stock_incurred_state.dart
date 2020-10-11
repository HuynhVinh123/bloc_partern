import 'package:tpos_api_client/tpos_api_client.dart';

class ReportStockIncurredState {}

/// Chạy loading khi load trang tổng quan
class ReportStockIncurredLoading extends ReportStockIncurredState {}

/// Chạy loading khi thực hiện load more trang tổng quan
class ReportStockIncurredLoadMoreLoading extends ReportStockIncurredState {}

/// Trả về dữ liệu khi thực hiện load filter thành công
class ReportStockIncurredLoadSuccess extends ReportStockIncurredState {
  ReportStockIncurredLoadSuccess({this.reportStockIncurred});
  final ReportStock reportStockIncurred;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class ReportStockIncurredLoadFailure extends ReportStockIncurredState {
  ReportStockIncurredLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
