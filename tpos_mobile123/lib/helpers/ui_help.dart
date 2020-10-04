import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tpos_mobile/application/application/language_bloc.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/extensions/extensions.dart';

Future<dynamic> showTextInputDialog(BuildContext context, String text,
    [bool autoFocus = false]) async {
  final TextEditingController _controller = TextEditingController(text: text);

  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      title: Text("Nhập nội dung:"),
      content: TextField(
        controller: _controller,
        autofocus: autoFocus,
        maxLines: null,
      ),
      actions: <Widget>[
        RaisedButton.icon(
          onPressed: () {
            Navigator.pop(context, _controller.text.trim());
          },
          icon: Icon(Icons.check),
          label: Text("XONG"),
          textColor: Colors.white,
        )
      ],
    ),
  );
}

Future urlLauch(String link) async {
  const url = 'https://flutter.dev';
  if (await canLaunch(link)) {
    await launch(link);
    print("lauch $link");
  } else {
    //throw 'Could not launch $url';
    print("can't send");
  }
}

class BottomBackButton extends StatelessWidget {
  final String content;
  const BottomBackButton({this.content = "QUAY LẠI"});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: RaisedButton.icon(
        icon: Icon(Icons.keyboard_return),
        label: Text(content),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
      ),
    );
  }
}

/// HIện bottom sheet hiện bảng chọn ngôn ngữ cho ứng dụng
Future<void> showLanguageSelect(BuildContext context) async {
  return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return BlocBuilder<LanguageBloc, LanguageState>(
            builder: (context, LanguageState languageState) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 60,
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          S.of(context).selectLanguage,
                          style: const TextStyle(
                              color: Color(0xFF2C333A), fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 60,
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1,
              ),
              ...S.delegate.supportedLocales
                  .map(
                    (Locale e) => _LanguageItem(
                      locale: e,
                      selected:
                          languageState.locale.languageCode == e.languageCode,
                    ),
                  )
                  .toList(),
              const SizedBox(
                height: 40,
              ),
            ]),
          );
        });
      });
}

class _LanguageItem extends StatelessWidget {
  const _LanguageItem({Key key, this.locale, this.selected = false})
      : super(key: key);
  final Locale locale;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: locale.getIcon(),
      title: Text(locale.getText()),
      subtitle: Text(locale.getDescription()),
      selected: selected,
      onTap: () {
        context.bloc<LanguageBloc>().add(LanguageChanged(locale.languageCode));
        Navigator.of(context).pop();
      },
      trailing: Icon(
        Icons.check_circle,
        color: selected ? const Color(0xFF28A745) : const Color(0xFFDFE5E9),
      ),
    );
  }
}
