import 'package:tpos_api_client/tpos_api_client.dart';

abstract class ProductUomAddEditEvent {}

class ProductUomAddEditStarted extends ProductUomAddEditEvent {
  ProductUomAddEditStarted({this.productUom, this.productUomCategory});

  final ProductUOM productUom;
  final ProductUomCategory productUomCategory;
}

class ProductUomAddEditUpdateLocal extends ProductUomAddEditEvent {
  ProductUomAddEditUpdateLocal({this.productUom});

  final ProductUOM productUom;
}

class ProductUomAddEditSaved extends ProductUomAddEditEvent {
  ProductUomAddEditSaved({this.productUom});

  final ProductUOM productUom;
}

class ProductUomAddEditDeleteTemporary extends ProductUomAddEditEvent {
  ProductUomAddEditDeleteTemporary({this.productUom});

  final ProductUOM productUom;
}

class ProductUomAddEditDeleted extends ProductUomAddEditEvent {
  ProductUomAddEditDeleted({this.productUom});

  final ProductUOM productUom;
}
