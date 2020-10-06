class Payment {
  Payment(
      {this.name,
      this.amountPaid,
      this.amountTotal,
      this.amountTax,
      this.amountReturn,
      this.discount,
      this.discountType,
      this.discountFixed,
      this.lines,
      this.statementIds,
      this.posSessionId,
      this.partnerId,
      this.taxId,
      this.userId,
      this.uid,
      this.sequenceNumber,
      this.creationDate,
      this.tableId,
      this.floor,
      this.floorId,
      this.customerCount,
      this.loyaltyPoints,
      this.wonPoints,
      this.spentPoints,
      this.totalPoints});

  Payment.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    amountPaid = json['amount_paid'];
    amountTotal = json['amount_total'];
    amountTax = json['amount_tax'];
    amountReturn = json['amount_return'];
    discount = json['discount'];
    discountType = json['discount_type'];
    discountFixed = json['discount_fixed'];
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines.add(Lines.fromJson(v));
      });
    }
    if (json['statement_ids'] != null) {
      statementIds = <StatementIds>[];
      json['statement_ids'].forEach((v) {
        statementIds.add(StatementIds.fromJson(v));
      });
    }
    posSessionId = json['pos_session_id'];
    partnerId = json['partner_id'];
    taxId = json['tax_id'];
    userId = json['user_id'];
    uid = json['uid'];
    sequenceNumber = json['sequence_number'];
    creationDate = json['creation_date'];
    tableId = json['table_id'];
    floor = json['floor'];
    floorId = json['floor_id'];
    customerCount = json['customer_count'];
    loyaltyPoints = json['loyalty_points'];
    wonPoints = json['won_points'];
    spentPoints = json['spent_points'];
    totalPoints = json['total_points'];
  }

  String name;
  double amountPaid;
  double amountTotal;
  double amountTax;
  double amountReturn;
  double discount;
  String discountType;
  double discountFixed;
  List<Lines> lines = [];
  List<StatementIds> statementIds = [];
  int posSessionId;
  int partnerId;
  int taxId;
  String userId;
  String uid;
  int sequenceNumber;
  String creationDate;
  String tableId;
  String floor;
  String floorId;
  int customerCount;
  int loyaltyPoints;
  int wonPoints;
  int spentPoints;
  int totalPoints;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['amount_paid'] = amountPaid;
    data['amount_total'] = amountTotal;
    data['amount_tax'] = amountTax;
    data['amount_return'] = amountReturn;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['discount_fixed'] = discountFixed;
    if (lines != null) {
      data['lines'] = lines.map((v) => v.toJson()).toList();
    }
    if (statementIds != null) {
      data['statement_ids'] = statementIds.map((v) => v.toJson()).toList();
    }
    data['pos_session_id'] = posSessionId;
    data['partner_id'] = partnerId;
    data['tax_id'] = taxId;
    data['user_id'] = userId;
    data['uid'] = uid;
    data['sequence_number'] = sequenceNumber;
    data['creation_date'] = creationDate;
    data['table_id'] = tableId;
    data['floor'] = floor;
    data['floor_id'] = floorId;
    data['customer_count'] = customerCount;
    data['loyalty_points'] = loyaltyPoints;
    data['won_points'] = wonPoints;
    data['spent_points'] = spentPoints;
    data['total_points'] = totalPoints;
    return data;
  }
}

class Lines {
  Lines(
      {this.qty,
      this.priceUnit,
      this.discount,
      this.productId,
      this.uomId,
      this.discountType,
      this.id,
      this.note,
      // ignore: non_constant_identifier_names
      this.tb_cart_position,
      this.productName,
      this.promotionProgramId,
      this.isPromotion,
      this.uomName,
      this.image});

  Lines.fromJson(Map<String, dynamic> json) {
    qty = json['qty'];
    priceUnit = json['price_unit'];
    discount = json['discount'];
    productId = json['product_id'];
    uomId = json['uom_id'];
    discountType = json['discount_type'];
    id = json['id'];
    note = json['note'];
    tb_cart_position = json['tb_cart_position'];
    productName = json['productName'];
    promotionProgramId = json["promotionprogram_id"];
    if (json["IsPromotion"] == 1) {
      isPromotion = true;
    } else {
      isPromotion = false;
    }
    uomName = json["uomName"];
    image = json["image"];
  }

  int qty;
  double priceUnit;
  double discount;
  int productId;
  int uomId;
  String discountType;
  int id;
  String note;
  int promotionProgramId;

  // List<String> taxIds;
  // ignore: non_constant_identifier_names
  String tb_cart_position;
  String productName;
  bool isPromotion;
  String uomName;
  String image;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['qty'] = qty;
    data['price_unit'] = priceUnit;
    data['discount'] = discount;
    data['product_id'] = productId;
    data['uom_id'] = uomId;
    data['discount_type'] = discountType;
    data['note'] = note;
    if (uomName != null) {
      data["uomName"] = uomName;
    }
    if (image != null) {
      data["image"] = image;
    }
    if (tb_cart_position != null && productName != null) {
      data['tb_cart_position'] = tb_cart_position;
      data['productName'] = productName;
    }
    if (promotionProgramId != null) {
      data["promotionprogram_id"] = promotionProgramId;
    }
    if (isPromotion != null) {
      data["IsPromotion"] = isPromotion ? 1 : 0;
    }

    return data;
  }
}

class StatementIds {
  StatementIds(
      {this.name,
      this.statementId,
      this.accountId,
      this.journalId,
      this.amount,
      this.position});

  StatementIds.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    statementId = json['statement_id'];
    accountId = json['account_id'];
    journalId = json['journal_id'];
    amount = json['amount'];
  }

  String position;
  String name;
  int statementId;
  int accountId;
  int journalId;
  double amount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['statement_id'] = statementId;
    data['account_id'] = accountId;
    data['journal_id'] = journalId;
    data['amount'] = amount;
    if (position != null) {
      data['positon'] = position;
    }
    return data;
  }
}

class InvoicePayment {
  InvoicePayment({this.sequence, this.isCheck});
  InvoicePayment.fromJson(Map<String, dynamic> json) {
    sequence = json['sequence'];
    isCheck = json['isCheck'];
  }
  String sequence;
  int isCheck;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sequence'] = sequence;
    data['isCheck'] = isCheck;
    return data;
  }
}
