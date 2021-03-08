import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductTemplateDetailsState {}

class ProductTemplateDetailsLoadSuccess extends ProductTemplateDetailsState {
  ProductTemplateDetailsLoadSuccess({this.productTemplate, this.userPermission});

  final ProductTemplate productTemplate;
  final UserPermission userPermission;
}

class ProductTemplateDetailsStartSuccess
    extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsStartSuccess(
      {ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateDetailsInventoryLoadNoMore
    extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsInventoryLoadNoMore(
      {ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateDetailsStockMoveLoadNoMore
    extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsStockMoveLoadNoMore(
      {ProductTemplate productTemplate, UserPermission userRight})
      : super(productTemplate: productTemplate, userPermission: userRight);
}

class ProductTemplateDetailsActiveSetSuccess
    extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsActiveSetSuccess(
      {ProductTemplate productTemplate, UserPermission userRight, this.active})
      : super(productTemplate: productTemplate, userPermission: userRight);

  final bool active;
}

class ProductTemplateDetailsLoadFailure extends ProductTemplateDetailsState {
  ProductTemplateDetailsLoadFailure({this.error});

  final String error;
}

class ProductTemplateDetailsActiveSetFailure
    extends ProductTemplateDetailsState {
  ProductTemplateDetailsActiveSetFailure({this.error});

  final String error;
}

class ProductTemplateDetailsDeleteFailure extends ProductTemplateDetailsState {
  ProductTemplateDetailsDeleteFailure({this.error});

  final String error;
}
class ProductTemplateDetailsAssignTagFailure extends ProductTemplateDetailsState {
  ProductTemplateDetailsAssignTagFailure({this.error});

  final String error;
}
class ProductTemplateDetailsLoading extends ProductTemplateDetailsState {}

class ProductTemplateDetailsBusy extends ProductTemplateDetailsState {}

class ProductTemplateDetailsDeleteSuccess extends ProductTemplateDetailsState {}
class ProductTemplateDetailsAssignTagSuccess extends ProductTemplateDetailsLoadSuccess {
  ProductTemplateDetailsAssignTagSuccess({ProductTemplate productTemplate})
      : super(productTemplate: productTemplate);
}