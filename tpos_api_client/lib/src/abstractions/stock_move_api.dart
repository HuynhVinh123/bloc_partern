import 'package:tpos_api_client/src/model.dart';
import 'package:tpos_api_client/src/models/requests/get_product_template_stock_move_query.dart';

abstract class StockMoveApi {
  Future<OdataListResult<StockMove>> getProductTemplateStockMoves({GetProductTemplateStockMoveQuery query});


}
