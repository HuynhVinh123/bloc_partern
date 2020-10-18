class ReportStock {
  ReportStock({this.data, this.total, this.aggregates});

  ReportStock.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <ReportStockData>[];
      json['Data'].forEach((v) {
        data.add(ReportStockData.fromJson(v));
      });
    }
    total = json['Total'];
    aggregates = json['Aggregates'] != null
        ? Aggregates.fromJson(json['Aggregates'])
        : null;
  }

  List<ReportStockData> data;
  int total;
  Aggregates aggregates;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Total'] = total;
    if (aggregates != null) {
      data['Aggregates'] = aggregates.toJson();
    }
    return data;
  }
}

class ReportStockData {
  ReportStockData(
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

  ReportStockData.fromJson(Map<String, dynamic> json) {
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductCode'] = productCode;
    data['ProductName'] = productName;
    data['ProductBarcode'] = productBarcode;
    data['ProductUOMName'] = productUOMName;
    data['Begin'] = begin;
    data['Import'] = import;
    data['ImportReturn'] = importReturn;
    data['Export'] = export;
    data['ExportReturn'] = exportReturn;
    data['End'] = end;
    data['ProductTmplId'] = productTmplId;
    return data;
  }
}

class Aggregates {
  Aggregates({this.begin, this.import, this.export, this.end});

  Aggregates.fromJson(Map<String, dynamic> json) {
    begin = json['Begin'] != null
        ? StockReportAggregatesBegin.fromJson(json['Begin'])
        : null;
    import = json['Import'] != null
        ? StockReportAggregatesImport.fromJson(json['Import'])
        : null;
    export = json['Export'] != null
        ? StockReportAggregatesExport.fromJson(json['Export'])
        : null;
    end = json['End'] != null
        ? StockReportAggregatesEnd.fromJson(json['End'])
        : null;
  }

  StockReportAggregatesBegin begin;
  StockReportAggregatesImport import;
  StockReportAggregatesExport export;
  StockReportAggregatesEnd end;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (begin != null) {
      data['Begin'] = begin.toJson();
    }
    if (import != null) {
      data['Import'] = import.toJson();
    }
    if (export != null) {
      data['Export'] = export.toJson();
    }
    if (end != null) {
      data['End'] = end.toJson();
    }
    return data;
  }
}

class StockReportAggregatesBegin {
  StockReportAggregatesBegin({this.sum});

  StockReportAggregatesBegin.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class StockReportAggregatesImport {
  StockReportAggregatesImport({this.sum});

  StockReportAggregatesImport.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }

  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class StockReportAggregatesExport {
  StockReportAggregatesExport({this.sum});

  StockReportAggregatesExport.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}

class StockReportAggregatesEnd {
  StockReportAggregatesEnd({this.sum});

  StockReportAggregatesEnd.fromJson(Map<String, dynamic> json) {
    sum = json['sum']?.toDouble();
  }
  double sum;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sum'] = sum;
    return data;
  }
}
