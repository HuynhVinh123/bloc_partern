import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/product_template_details_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_event.dart';
import 'package:tpos_mobile/feature_group/category/product_template/bloc/details/stock_move/product_details_stock_move_state.dart';

class ProductDetailsStockMoveBloc extends Bloc<ProductDetailsStockMoveEvent, ProductDetailsStockMoveState> {
  ProductDetailsStockMoveBloc({StockMoveApi stockMoveApi}) : super(ProductDetailsStockMoveLoading()) {
    _stockMoveApi = stockMoveApi ?? GetIt.I<StockMoveApi>();
  }

  StockMoveApi _stockMoveApi;
  final Logger _logger = Logger();
  List<StockMove> _stockMoves = [];
  int _countStockMove = 0;
  int _productTemplateId;

  final Map<StockType, String> _stockTypeFilters = <StockType, String>{
    StockType.IMPORT: 'Nhập kho',
    StockType.EXPORT: 'Xuất kho',
    StockType.ALL: ''
  };

  @override
  Stream<ProductDetailsStockMoveState> mapEventToState(ProductDetailsStockMoveEvent event) async* {
    if (event is ProductDetailsStockMoveStarted) {
      try {
        yield ProductDetailsStockMoveLoading();
        _productTemplateId = event.productTemplateId;

        ///lấy danh sách stockMoves
        final GetProductTemplateStockMoveQuery stockMoveQuery =
            GetProductTemplateStockMoveQuery(top: 20, skip: 0, productTmplId: _productTemplateId);

        final OdataListResult<StockMove> stockMoveResult =
            await _stockMoveApi.getProductTemplateStockMoves(query: stockMoveQuery);
        _countStockMove = stockMoveResult.count;
        _stockMoves = stockMoveResult.value;
        yield ProductDetailsStockMoveLoadSuccess(stockMoves: _stockMoves);
      } catch (e, stack) {
        _logger.e('ProductDetailsStockMoveLoadFailure', e, stack);
        yield ProductDetailsStockMoveLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsStockMoveLoadMore) {
      try {
        ///lấy danh sách stockMoves
        if (_stockMoves.length < _countStockMove) {
          final GetProductTemplateStockMoveQuery stockMoveQuery =
              GetProductTemplateStockMoveQuery(top: 20, skip: _stockMoves.length, productTmplId: _productTemplateId);

          final OdataListResult<StockMove> stockMoveResult =
              await _stockMoveApi.getProductTemplateStockMoves(query: stockMoveQuery);
          _countStockMove = stockMoveResult.count;
          _stockMoves.addAll(stockMoveResult.value);

          yield ProductDetailsStockMoveLoadSuccess(stockMoves: _stockMoves);
        } else {
          yield ProductDetailsStockMoveLoadNoMore(stockMoves: _stockMoves);
        }
      } catch (e, stack) {
        _logger.e('ProductDetailsStockMoveLoadFailure', e, stack);
        yield ProductDetailsStockMoveLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsStockMoveFilter) {
      try {
        yield ProductDetailsStockMoveBusy();

        ///lấy danh sách stockMoves
        final GetProductTemplateStockMoveQuery stockMoveQuery = GetProductTemplateStockMoveQuery(
            top: 20,
            skip: 0,
            productTmplId: _productTemplateId,
            filter: 'contains(Type,\'${_stockTypeFilters[event.filter]}\')');

        final OdataListResult<StockMove> stockMoveResult =
            await _stockMoveApi.getProductTemplateStockMoves(query: stockMoveQuery);
        _countStockMove = stockMoveResult.count;
        _stockMoves = stockMoveResult.value;

        yield ProductDetailsStockMoveLoadSuccess(stockMoves: _stockMoves);
      } catch (e, stack) {
        _logger.e('ProductDetailsStockMoveLoadFailure', e, stack);
        yield ProductDetailsStockMoveLoadFailure(error: e.toString());
      }
    } else if (event is ProductDetailsStockMoveRefresh) {
      try {
        yield ProductDetailsStockMoveLoading();

        ///lấy danh sách stockMoves
        final GetProductTemplateStockMoveQuery stockMoveQuery =
            GetProductTemplateStockMoveQuery(top: 20, skip: 0, productTmplId: _productTemplateId);

        final OdataListResult<StockMove> stockMoveResult =
            await _stockMoveApi.getProductTemplateStockMoves(query: stockMoveQuery);
        _countStockMove = stockMoveResult.count;
        _stockMoves = stockMoveResult.value;
        yield ProductDetailsStockMoveLoadSuccess(stockMoves: _stockMoves);
      } catch (e, stack) {
        _logger.e('ProductDetailsStockMoveLoadFailure', e, stack);
        yield ProductDetailsStockMoveLoadFailure(error: e.toString());
      }
    }
  }
}
