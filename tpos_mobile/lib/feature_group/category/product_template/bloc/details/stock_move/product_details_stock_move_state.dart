import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductDetailsStockMoveState {}

class ProductDetailsStockMoveLoadSuccess extends ProductDetailsStockMoveState {
  ProductDetailsStockMoveLoadSuccess({this.stockMoves});

  final List<StockMove> stockMoves;
}

class ProductDetailsStockMoveLoadNoMore extends ProductDetailsStockMoveLoadSuccess {
  ProductDetailsStockMoveLoadNoMore({List<StockMove> stockMoves}) : super(stockMoves: stockMoves);
}

class ProductDetailsStockMoveLoadFailure extends ProductDetailsStockMoveState {
  ProductDetailsStockMoveLoadFailure({this.error});

  final String error;
}

class ProductDetailsStockMoveLoading extends ProductDetailsStockMoveState {}

class ProductDetailsStockMoveBusy extends ProductDetailsStockMoveState {}