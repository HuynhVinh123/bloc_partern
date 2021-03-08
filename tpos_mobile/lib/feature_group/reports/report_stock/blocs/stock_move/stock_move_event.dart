import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class StockMoveEvent {}

/// Event lấy danh sách tồn kho
class StockMoveLoaded extends StockMoveEvent {
  StockMoveLoaded(
      {this.skip, this.limit, this.stockFilter, this.productTmplId});
  final int limit;
  final int skip;
  final StockFilter stockFilter;
  final int productTmplId;
}

class StockMoveLoadMoreLoaded extends StockMoveEvent {
  StockMoveLoadMoreLoaded(
      {this.skip, this.limit, this.stockMoveProduct, this.productTmplId});
  final int limit;
  final int skip;
  final StockMoveProduct stockMoveProduct;
  final int productTmplId;
}
