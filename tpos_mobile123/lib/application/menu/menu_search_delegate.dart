import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:tpos_mobile/helpers/helpers.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';

class MenuSearchDelegate extends SearchDelegate {
  MenuSearchDelegate();

  bool isSuggesAll = false;
  final _resultChangedSubject = BehaviorSubject<String>();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            query = "";
          },
          child: Icon(
            Icons.cancel,
            color: Colors.black54,
            size: 16,
          ),
        ),
      ),
      FlatButton(
        textColor: Colors.blue,
        child: const Text("ĐÓNG"),
        onPressed: () {
          close(context, null);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Icon(Icons.search);
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query == "") {
      return _buildDefault(context);
    } else {
      return _buildResult();
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: Colors.white,
      primaryTextTheme: TextTheme(
        title: TextStyle(
          color: Colors.white70,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Buid default search result. it is recent that user go to link
  Widget _buildDefault(BuildContext context) {
    return const SizedBox();
  }

  Widget _buildResult() {
    final queryNoSign = query?.removeVietnameseMark(toLower: true);
    final results = applicationMenu
        .where((f) =>
            f.name().removeVietnameseMark(toLower: true).contains(queryNoSign))
        .toList();
    return Container(
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          indent: 26,
        ),
        itemBuilder: (context, index) {
          final menu = results[index];
          return ListTile(
              leading: CircleAvatar(
                child: menu.icon,
                backgroundColor: Colors.grey.shade300,
              ),
              title: Text(menu.name()),
              onTap: () {
                Navigator.pushNamed(context, menu.route);
              });
        },
        itemCount: results.length,
      ),
    );
  }

  @override
  void close(BuildContext context, result) {
    super.close(context, result);
    _resultChangedSubject.close();
  }
}
