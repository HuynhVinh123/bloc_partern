import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class StockFilterState{}

class StockFilterLoading extends StockFilterState {}

/// Trả về dữ liệu khi thực hiện filter thành công
class StockFilterLoadSuccess extends StockFilterState {
  StockFilterLoadSuccess(
      {this.stockFilter,this.countFilter =1});
    final StockFilter stockFilter;
    final int countFilter;
}
