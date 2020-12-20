import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductTemplateDetailsState {}

class ProductTemplateDetailsLoadSuccess extends ProductTemplateDetailsState {
  ProductTemplateDetailsLoadSuccess({this.productTemplate});

  final ProductTemplate productTemplate;
}


class ProductTemplateDetailsStartSuccess extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsStartSuccess({ProductTemplate productTemplate})
      : super(productTemplate: productTemplate);
}

class ProductTemplateDetailsInventoryLoadNoMore extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsInventoryLoadNoMore({ProductTemplate productTemplate})
      : super(productTemplate: productTemplate);
}

class ProductTemplateDetailsStockMoveLoadNoMore extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsStockMoveLoadNoMore({ProductTemplate productTemplate})
      : super(productTemplate: productTemplate);
}

class ProductTemplateDetailsActiveSetSuccess extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsActiveSetSuccess({ProductTemplate productTemplate, this.active})
      : super(productTemplate: productTemplate);

  final bool active;
}

class ProductTemplateDetailsLoadFailure extends ProductTemplateDetailsState {
  ProductTemplateDetailsLoadFailure({this.error});

  final String error;
}

class ProductTemplateDetailsActiveSetFailure extends ProductTemplateDetailsState {
  ProductTemplateDetailsActiveSetFailure({this.error});

  final String error;
}

class ProductTemplateDetailsDeleteFailure extends ProductTemplateDetailsState {
  ProductTemplateDetailsDeleteFailure({this.error});

  final String error;
}

class ProductTemplateDetailsLoading extends ProductTemplateDetailsState {}

class ProductTemplateDetailsBusy extends ProductTemplateDetailsState {}

class ProductTemplateDetailsDeleteSuccess extends ProductTemplateDetailsState {}
