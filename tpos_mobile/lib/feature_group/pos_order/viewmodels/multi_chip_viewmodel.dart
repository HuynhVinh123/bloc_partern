import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';

class MultiChipViewModel extends ViewModelBase {
  MultiChipViewModel();

  double amountHandle = 0;

  void handleMoney({double amountTotal, String amountDebtStr}) {
    final double amountDebt = double.parse(amountDebtStr.replaceAll(".", ""));
    if (amountTotal > 0) {
      amountHandle = amountTotal - amountDebt;
    } else {
      amountHandle = -amountTotal + amountDebt;
    }
    notifyListeners();
  }
}
