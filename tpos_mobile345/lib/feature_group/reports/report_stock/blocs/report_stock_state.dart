import 'package:tpos_api_client/tpos_api_client.dart';

class ReportStockState {}

/// Chạy loading khi load trang tổng quan
class ReportStockLoading extends ReportStockState {}

/// Chạy loading khi thực hiện load more trang tổng quan
class ReportStockLoadMoreLoading extends ReportStockState {}

/// Trả về dữ liệu khi thực hiện load filter thành công
class ReportStockLoadSuccess extends ReportStockState {
  ReportStockLoadSuccess({this.reportStock});
  final ReportStock reportStock;
}

/// Chạy loading khi load trang tổng quan
class ReportStockExtLoading extends ReportStockState {}

/// Chạy loading khi thực hiện load more trang tổng quan
class ReportStockExtLoadMoreLoading extends ReportStockState {}

/// Trả về dữ liệu khi thực hiện load filter thành công
class ReportStockExtLoadSuccess extends ReportStockState {
  ReportStockExtLoadSuccess({this.reportStock});
  final ReportStock reportStock;
}

/// Báo lỗi khi thực hiện lấy danh sách dữ liệu thất bại
class ReportStockLoadFailure extends ReportStockState {
  ReportStockLoadFailure({this.title, this.content});

  final String title;
  final String content;
}
