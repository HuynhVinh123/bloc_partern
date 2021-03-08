import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/button/app_button.dart';
import 'package:tpos_mobile/widgets/money_format_controller.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class NumberInputDialog extends StatefulWidget {
  const NumberInputDialog({Key key, this.initValue, this.selectAllText = true, this.hint, this.allowNegative = false})
      : super(key: key);

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
  final double initValue;
  final bool selectAllText;
  final bool allowNegative;
  final String hint;
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  CustomMoneyMaskedTextController _valueController;

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _valueController.dispose();
    _focusNode.dispose();
  }

  @override
  void initState() {
    _valueController = CustomMoneyMaskedTextController(
        thousandSeparator: '.', decimalSeparator: '', precision: 0, allowNagative: widget.allowNegative);
    _valueController.text = widget.initValue.toStringAsFixed(0);
    if (widget.selectAllText) {
      _focusNode.addListener(() {
        if (_focusNode.hasFocus) {
          _valueController.selection = TextSelection(baseOffset: 0, extentOffset: _valueController.text.length);
        }
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(null);
          return false;
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              padding: const EdgeInsets.only(left: 20, right: 20),
              height: 200,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _valueController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    focusNode: _focusNode,
                    textAlign: TextAlign.start,
                    style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 5),
                      hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff28A745)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: AppButton(
                            width: null,
                            height: 42,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: const Color(0xffC6C6C6), width: 1)),
                            background: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pop(null);
                            },
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Center(
                                  child: Text(
                                    S.current.close,
                                    style: const TextStyle(color: Color(0xff2C333A)),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: AppButton(
                            width: null,
                            height: 42,
                            background: const Color(0xff28A745),
                            borderRadius: 6,
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            onPressed: () {
                              Navigator.of(context).pop(_valueController.numberValue);
                            },
                            child: Container(
                                alignment: Alignment.centerRight,
                                child: Center(
                                  child: Text(
                                    S.current.confirm,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<double> showNumberInputDialog(BuildContext context, double initValue, {bool allowNegative = false}) {
  return showCustomDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
          child: NumberInputDialog(
            initValue: initValue,
            allowNegative: allowNegative,
          ),
        );
      },
      useRootNavigator: false);
}

Future<T> showCustomDialog<T>({
  @required BuildContext context,
  bool barrierDismissible = true,
  WidgetBuilder builder,
  bool useRootNavigator = true,
  RouteSettings routeSettings,
}) {
  assert(useRootNavigator != null);
  assert(debugCheckHasMaterialLocalizations(context));

  final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return Builder(builder: (BuildContext context) {
        return theme != null ? Theme(data: theme, child: pageChild) : pageChild;
      });
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 150),
    transitionBuilder: _buildMaterialDialogTransitions,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
  );
}

Widget _buildMaterialDialogTransitions(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}
