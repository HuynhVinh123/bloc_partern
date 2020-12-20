import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/src/tpos_apis/models/product_search_order_by.dart';

abstract class ProductTemplateState {
  ProductTemplateState(
      {this.productTemplates,
      this.orderBy,
      this.filterTags,
      this.productPrice,
      this.productCategories,
      this.isFilterProductPrice,
      this.isFilterCategory,
      this.isFilterTag,
      this.tags,
      this.productPrices,
      this.productTemplateExecutes,
      this.selectedAll});

  BaseListOrderBy orderBy;
  List<ProductTemplate> productTemplates;
  List<ProductTemplate> productTemplateExecutes;
  List<ProductCategory> productCategories;
  List<Tag> filterTags;

  ProductPrice productPrice;
  List<Tag> tags;
  List<ProductPrice> productPrices;
  bool isFilterCategory;
  bool isFilterProductPrice;
  bool isFilterTag;
  bool selectedAll;

  void copyWith(ProductTemplateState state) {
    orderBy = state.orderBy;
    productTemplates = state.productTemplates;
    productTemplateExecutes = state.productTemplateExecutes;
    productCategories = state.productCategories;
    filterTags = state.filterTags;
    productPrice = state.productPrice;
    tags = state.tags;
    productPrices = state.productPrices;
    isFilterCategory = state.isFilterCategory;
    isFilterProductPrice = state.isFilterProductPrice;
    isFilterTag = state.isFilterTag;
    selectedAll = state.selectedAll;
  }

}

class ProductTemplateLoading extends ProductTemplateState {
  ProductTemplateLoading(
      {BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);
}

class ProductTemplateBusy extends ProductTemplateState {
  ProductTemplateBusy(
      {BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);
}

class ProductTemplateLoadFailure extends ProductTemplateState {
  ProductTemplateLoadFailure(
      {this.error,
      BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);

  final String error;
}

class ProductTemplateDeleteFailure extends ProductTemplateState {
  ProductTemplateDeleteFailure(
      {this.error,
      BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);

  final String error;
}

class ProductTemplateDeleteSuccess extends ProductTemplateLoadSuccess {
  ProductTemplateDeleteSuccess(
      {BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);
}

class ProductTemplateLoadSuccess extends ProductTemplateState {
  ProductTemplateLoadSuccess(
      {BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);
}

class ProductTemplateLoadNoMore extends ProductTemplateLoadSuccess {
  ProductTemplateLoadNoMore(
      {BaseListOrderBy orderBy,
      List<ProductTemplate> productTemplates,
      List<ProductTemplate> productTemplateExecutes,
      List<ProductCategory> productCategories,
      List<Tag> filterTags,
      List<Tag> tags,
      ProductPrice productPrice,
      bool isFilterCategory,
      bool isFilterProductPrice,
      bool isFilterTag,
      List<ProductPrice> productPrices,
      bool selectedAll})
      : super(
            orderBy: orderBy,
            productTemplates: productTemplates,
            productCategories: productCategories,
            filterTags: filterTags,
            tags: tags,
            productPrice: productPrice,
            isFilterCategory: isFilterCategory,
            isFilterProductPrice: isFilterProductPrice,
            isFilterTag: isFilterTag,
            productPrices: productPrices,
            productTemplateExecutes: productTemplateExecutes,
            selectedAll: selectedAll);
}
