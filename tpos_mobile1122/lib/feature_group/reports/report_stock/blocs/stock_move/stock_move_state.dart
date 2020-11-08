import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class StockMoveState {}

/// Loading trong khi đợi load dữ liệu
class StockMoveLoading extends StockMoveState {}

class StockMoveLoadMoreLoading extends StockMoveState {}

/// Trả về dữ liệu khi laod thành công
class StockMoveLoadSuccess extends StockMoveState {
  StockMoveLoadSuccess({this.stockMoveProduct});
  final StockMoveProduct stockMoveProduct;
}

/// Trả về lỗi khi load thất bại
class StockMoveLoadFailure extends StockMoveState {
  StockMoveLoadFailure({this.title, this.content});
  final String title;
  final String content;
}
