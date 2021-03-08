/// Trả về từ api https://tmt25.tpos.vn/odata/SaleOrder/ODataService.SumAmountReport3TypeSale?BeginDate=2020-09-01T00%3A00%3A00&EndDate=2020-09-22T16%3A45%3A26&PartnerId=&StaffId=&OrderType=&CompanyId=&TypeReport=1
///
class SumDataSale {
  SumDataSale(
      {this.odataContext,
      this.sumAmountSaleOrder,
      this.sumAmountPostOrder,
      this.sumAmountFastOrder,
      this.sumPaidtSaleOrder,
      this.sumPaidPostOrder,
      this.sumPaidFastOrder,
      this.sumAmountBeforeDiscountPostOrder,
      this.sumAmountBeforeDiscountFastOrder,
      this.sumDiscountAmountPostOrder,
      this.sumDiscountAmountFastOrder,
      this.sumDecreateAmountPostOrder,
      this.sumDecreateAmountFastOrder});

  SumDataSale.fromJson(Map<String, dynamic> json) {
    odataContext = json['@odata.context'];
    sumAmountSaleOrder = json['SumAmountSaleOrder']?.toDouble();
    sumAmountPostOrder = json['SumAmountPostOrder']?.toDouble();
    sumAmountFastOrder = json['SumAmountFastOrder']?.toDouble();
    sumPaidtSaleOrder = json['SumPaidtSaleOrder']?.toDouble();
    sumPaidPostOrder = json['SumPaidPostOrder']?.toDouble();
    sumPaidFastOrder = json['SumPaidFastOrder']?.toDouble();
    sumAmountBeforeDiscountPostOrder =
        json['SumAmountBeforeDiscountPostOrder']?.toDouble();
    sumAmountBeforeDiscountFastOrder =
        json['SumAmountBeforeDiscountFastOrder']?.toDouble();
    sumDiscountAmountPostOrder = json['SumDiscountAmountPostOrder']?.toDouble();
    sumDiscountAmountFastOrder = json['SumDiscountAmountFastOrder']?.toDouble();
    sumDecreateAmountPostOrder = json['SumDecreateAmountPostOrder']?.toDouble();
    sumDecreateAmountFastOrder = json['SumDecreateAmountFastOrder']?.toDouble();
  }

  String odataContext;
  double sumAmountSaleOrder;
  double sumAmountPostOrder;
  double sumAmountFastOrder;
  double sumPaidtSaleOrder;
  double sumPaidPostOrder;
  double sumPaidFastOrder;
  double sumAmountBeforeDiscountPostOrder;
  double sumAmountBeforeDiscountFastOrder;
  double sumDiscountAmountPostOrder;
  double sumDiscountAmountFastOrder;
  double sumDecreateAmountPostOrder;
  double sumDecreateAmountFastOrder;
}
