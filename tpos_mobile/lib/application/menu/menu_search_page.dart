import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tmt_flutter_untils/tmt_flutter_extensions.dart';
import 'package:tpos_mobile/resources/menus.dart';
import 'package:tpos_mobile/widgets/load_status.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class MenuSearchPage extends StatefulWidget {
  @override
  _MenuSearchPageState createState() => _MenuSearchPageState();
}

class _MenuSearchPageState extends State<MenuSearchPage> {
  final TextEditingController _keywordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    _keywordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(70 + MediaQuery.of(context).padding.top),
      child: Container(
        height: 70 + MediaQuery.of(context).padding.top,
        width: double.infinity,
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 10,
          right: 16,
        ),
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment(-1.0, 1.0), end: Alignment(0.5, -1.0), stops: [
          0.1,
          0.5,
          0.5,
          0.9
        ], colors: [
          Color(0xff1d7d27),
          Color(0xff3ba734),
          Color(0xff43af35),
          Color(0xff63c938),
        ])),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 50,
                height: 50,
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    iconSize: 30,
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(43, 237, 242, 246), borderRadius: BorderRadius.circular(24)),
                height: 40,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(width: 12),
                      const Icon(Icons.search, color: Colors.white),
                      Expanded(
                        child: Center(
                          child: Container(
                              height: 35,
                              margin: const EdgeInsets.only(left: 4),
                              child: Center(
                                child: TextField(
                                  controller: _keywordController,
                                  focusNode: _focusNode,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(0),
                                      isDense: true,
                                      hintText: 'Nhập tên cần tìm',
                                      hintStyle: TextStyle(color: Colors.white.withAlpha(137)),
                                      border: InputBorder.none),
                                ),
                              )),
                        ),
                      ),
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 40,
                              height: 40,
                              child: Material(
                                color: Colors.transparent,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.white),
                                  onPressed: () async {
                                    _keywordController.text = '';
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                          // IconButton(
                          //   constraints: const BoxConstraints(
                          //     minWidth: 24,
                          //     minHeight: 48,
                          //   ),
                          //   padding: const EdgeInsets.all(0.0),
                          //   icon: const Icon(
                          //     Icons.close,
                          //     color: Colors.white,
                          //     size: 19,
                          //   ),
                          //   onPressed: () {
                          //     _keywordController.text = '';
                          //   },
                          // ),
                          // const Padding(
                          //   padding: EdgeInsets.only(top: 10, bottom: 10, left: 5),
                          //   child: VerticalDivider(
                          //     width: 1,
                          //     color: Color.fromARGB(79, 207, 253, 190),
                          //   ),
                          // )
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    final results = applicationMenu
        .where((f) => f.name().removeVietnameseMark(toLower: true).contains(_keywordController.text))
        .toList();
    return results.isEmpty
        ? _buildEmptyList()
        : ListView.separated(
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
          );
  }

  Widget _buildEmptyList() {
    return SingleChildScrollView(
        child: Column(
      children: [
        // if (_check) _buildCheckAction() else _buildUncheckAction(),
        SizedBox(height: 50 * (MediaQuery.of(context).size.height / 700)),
        LoadStatusWidget(
          statusName: S.current.searchNotFound,
          content: '${S.current.searchNotFoundWithKeyword} "${_keywordController.text}". ${S.current.searchProductAgain}',
          statusIcon: SvgPicture.asset('assets/icon/no-result.svg', width: 170, height: 130),
        ),
      ],
    ));
  }
}
