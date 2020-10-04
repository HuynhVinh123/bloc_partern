class PrinterSetting {
  PrinterSetting(
      {this.printSize,
      this.printOrientation,
      this.printerInfo,
      this.supportPrintSizes,
      this.printerName});
  PrintSize printSize;
  PrintOrientation printOrientation;
  String printerInfo;
  List<SupportPrintSize> supportPrintSizes;
  String printerName;

  String get printSizeAndOrienttation =>
      "${printSize.toString().replaceAll("PrintSize.", "")}_${printOrientation.toString().replaceAll("PrintOrientation.", "")}";
}

class SupportPrintSize {
  SupportPrintSize(this.name, this.code);
  final String name;
  final String code;
}

enum PrintSize {
  WEB,
  A5,
  A4,
  BILL80,
  BILL58,
}

enum PrintOrientation {
  PORTRAIT,
  LANDSCAPE,
}
