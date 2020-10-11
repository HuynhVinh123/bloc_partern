import 'package:tpos_mobile/src/tpos_apis/models/filter_stock.dart';

class StockFilterEvent {}

/// Load dữ liêu filter khi mới vào page
class StockFilterLoaded extends StockFilterEvent {}

/// Thực hiện thay đổi filter
class StockFilterChanged extends StockFilterEvent {
  StockFilterChanged(
      {this.stockFilter});

  final StockFilter stockFilter;
}
