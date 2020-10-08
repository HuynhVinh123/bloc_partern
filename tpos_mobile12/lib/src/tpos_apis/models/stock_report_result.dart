class StockReport {
  List<StockReportData> data;
  int total;
  Aggregates aggregates;

  StockReport({this.data, this.total, this.aggregates});

  StockReport.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = new List<StockReportData>();
      json['Data'].forEach((v) {
        data.add(new StockReportData.fromJson(v));
      });
    }
    total = json['Total'];
    aggregates = json['Aggregates'] != null
        ? new Aggregates.fromJson(json['Aggregates'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Total'] = this.total;
    if (this.aggregates != null) {
      data['Aggregates'] = this.aggregates.toJson();
    }
    return data;
  }
}

class StockReportData {
  String productCode;
  String productName;
  String productBarcode;
  String productUOMName;
  double begin;
  double import;
  double importReturn;
  double export;
  double exportReturn;
  double end;
  int productTmplId;

  StockReportData(
      {this.productCode,
      this.productName,
      this.productBarcode,
      this.productUOMName,
      this.begin,
      this.import,
      this.importReturn,
      this.export,
      this.exportReturn,
      this.end,
      this.productTmplId});

  StockReportData.fromJson(Map<String, dynamic> json) {
    productCode = json['ProductCode'];
    productName = json['ProductName'];
    productBarcode = json['ProductBarcode'];
    productUOMName = json['ProductUOMName'];
    begin = json['Begin']?.toDouble();
    import = json['Import']?.toDouble();
    importReturn = json['ImportReturn']?.toDouble();
    export = json['Export']?.toDouble();
    exportReturn = json['ExportReturn']?.toDouble();
    end = json['End'];
    productTmplId = json['ProductTmplId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductCode'] = this.productCode;
    data['ProductName'] = this.productName;
    data['ProductBarcode'] = this.productBarcode;
    data['ProductUOMName'] = this.productUOMName;
    data['Begin'] = this.begin;
    data['Import'] = this.import;
    data['ImportReturn'] = this.importReturn;
    data['Export'] = this.export;
    data['ExportReturn'] = this.exportReturn;
    data['End'] = this.end;
    data['ProductTmplId'] = this.productTmplId;
    return data;
  }
}

class Aggregates {
  StockReportAggregatesBegin begin;
  StockReportAggregatesImport import;
  StockReportAggregatesExport export;
  StockReportAggregatesEnd end;

  Aggregates({this.begin, this.import, this.export, this.end});

  Aggregates.fromJson(Map<String, dynamic> json) {
    begin = json['Begin'] != null
        ? new StockReportAggregatesBegin.fromJson(json['Begin'])
        : null;
    import = json['Import'] != null
        ? new StockReportAggregatesImport.fromJson(json['Import'])
        : null;
    export = json['Export'] != null
        ? new StockReportAggregatesExport.fromJson(json['Export'])
        : null;
    end = json['End'] != null
        ? new StockReportAggregatesEnd.fromJson(json['End'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.begin != null) {
      data['Begin'] = this.begin.toJson();
    }
    if (this.import != null) {
      data['Import'] = this.import.toJson();
    }
    if (this.export != null) {
      data['Export'] = this.export.toJson();
    }
    if (this.end != null) {
      data['End'] = this.end.toJson();
    }
    return data;
  }
}

class StockReportAggregatesBegin {
  double sum;

  StockReportAggregatesBegin({this.sum});

  StockReportAggregatesBegin.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    return data;
  }
}

class StockReportAggregatesImport {
  double sum;

  StockReportAggregatesImport({this.sum});

  StockReportAggregatesImport.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    return data;
  }
}

class StockReportAggregatesExport {
  double sum;

  StockReportAggregatesExport({this.sum});

  StockReportAggregatesExport.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    return data;
  }
}

class StockReportAggregatesEnd {
  double sum;

  StockReportAggregatesEnd({this.sum});

  StockReportAggregatesEnd.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sum'] = this.sum;
    return data;
  }
}
