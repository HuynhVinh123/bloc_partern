import 'package:tpos_api_client/tpos_api_client.dart';

enum StockType {
  IMPORT,
  EXPORT,
  ALL,
}

abstract class ProductTemplateDetailsEvent {}

class ProductTemplateDetailsStarted extends ProductTemplateDetailsEvent {
  ProductTemplateDetailsStarted({this.productTemplate});

  final ProductTemplate productTemplate;
}


class ProductTemplateDetailsRefresh extends ProductTemplateDetailsEvent {}

class ProductTemplateDetailsActiveSet extends ProductTemplateDetailsEvent {
  ProductTemplateDetailsActiveSet({this.active = false});

  final bool active;
}


class ProductTemplateDetailsDelete extends ProductTemplateDetailsEvent {}
