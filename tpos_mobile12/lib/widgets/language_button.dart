import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tpos_mobile/application/application/language_bloc.dart';
import 'package:tpos_mobile/helpers/ui_help.dart';
import 'package:tpos_mobile_localization/generated/l10n.dart';
import 'package:tpos_mobile/extensions/extensions.dart';

/// Nút nhấn để chọn ngôn ngữ ứng dụng
class SelectLanguageButton extends StatelessWidget {
  const SelectLanguageButton({Key key, this.showText = false, this.onChanged})
      : super(key: key);
  final bool showText;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
      final locale = Locale(S.of(context).languageCode);
      return FlatButton.icon(
        onPressed: () async {
          await showLanguageSelect(context);
          await Future.delayed(const Duration(milliseconds: 500));
          if (onChanged != null) {
            onChanged();
          }
        },
        icon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: locale.getIcon(),
        ),
        label: Text(locale.getText()),
      );
    });
  }
}
