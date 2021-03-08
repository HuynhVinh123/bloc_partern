class GetPartnerByIdQuery {
  const GetPartnerByIdQuery(
      {this.expand =
          'PurchaseCurrency,Categories,AccountPayable,AccountReceivable,StockCustomer,StockSupplier,Title,PropertyProductPricelist,PropertySupplierPaymentTerm,PropertyPaymentTerm'});
  factory GetPartnerByIdQuery.fromDefault() {
    return const GetPartnerByIdQuery(
        expand:
            'PurchaseCurrency,Categories,AccountPayable,AccountReceivable,StockCustomer,StockSupplier,Title,PropertyProductPricelist,PropertySupplierPaymentTerm,PropertyPaymentTerm');
  }
  final String expand;

  Map<String, dynamic> toJson([bool removeIfNull = false]) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['\$expand'] = expand;
    if (removeIfNull) {
      data.removeWhere((key, value) => value == null);
    }
    return data;
  }
}
