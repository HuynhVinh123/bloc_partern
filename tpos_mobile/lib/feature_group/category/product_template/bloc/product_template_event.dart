import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_search_order_by.dart';

abstract class ProductTemplateEvent {}

class ProductTemplateLoaded extends ProductTemplateEvent {}

class ProductTemplateLoadedMore extends ProductTemplateEvent {}

class ProductTemplateStarted extends ProductTemplateEvent {
  ProductTemplateStarted({this.search});

  String search;
}

class ProductTemplateFiltered extends ProductTemplateEvent {
  ProductTemplateFiltered({
    this.isFilterByCategory,
    this.isFilterByProductPrice,
    this.isFilterByTag,
  });

  bool isFilterByCategory;
  bool isFilterByProductPrice;
  bool isFilterByTag;
}

class ProductTemplateFilterAdded extends ProductTemplateEvent {
  ProductTemplateFilterAdded({this.productCategories, this.filterTags, this.productPrice});

  final List<ProductCategory> productCategories;
  final List<Tag> filterTags;
  final ProductPrice productPrice;
}

class ProductTemplateSearched extends ProductTemplateEvent {
  ProductTemplateSearched({this.search});

  String search;
}

class ProductTemplateRefreshed extends ProductTemplateEvent {}

class ProductTemplateDeleteSelected extends ProductTemplateEvent {}

class ProductTemplateExecuteAdded extends ProductTemplateEvent {
  ProductTemplateExecuteAdded({this.productTemplate});

  ProductTemplate productTemplate;
}

class ProductTemplateExecuteRemoved extends ProductTemplateEvent {
  ProductTemplateExecuteRemoved({this.productTemplate});

  ProductTemplate productTemplate;
}

class ProductTemplateSelectAll extends ProductTemplateEvent {
  ProductTemplateSelectAll({this.check});

  final bool check;
}

class ProductTemplateSorted extends ProductTemplateEvent {
  ProductTemplateSorted({this.orderBy});

  BaseListOrderBy orderBy;
}

class ProductTemplateRemoved extends ProductTemplateEvent {
  ProductTemplateRemoved({this.productTemplate});

  ProductTemplate productTemplate;
}

class ProductTemplateAssignTag extends ProductTemplateEvent {
  ProductTemplateAssignTag({this.tags, this.productTemplate});

  final ProductTemplate productTemplate;
  final List<Tag> tags;
}

class ProductTemplateRemoveTag extends ProductTemplateEvent {
  ProductTemplateRemoveTag({this.tag, this.productTemplate});

  final ProductTemplate productTemplate;
  final Tag tag;
}

class ProductTemplateOpenFilter extends ProductTemplateEvent {}
