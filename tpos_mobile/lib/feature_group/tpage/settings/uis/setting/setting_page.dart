import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  List<String> settings = [];
  List<Map<String, dynamic>> isSettings = [];
  bool isHideComment = false;
  final TextEditingController _keyController = TextEditingController();
  List<String> keyWords = ["Mua hàng"];

  @override
  void initState() {
    super.initState();
    settings.add("Ẩn bình luận chứa số điện thoại");
    settings.add("Ẩn bình luận chứa email");
    settings.add("Ẩn bình luận chứa từ khóa");
    isSettings.add({"key": false});
    isSettings.add({"key": false});
    isSettings.add({"key": false});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFEBEDEF),
        appBar: AppBar(
          title: const Text("Cài đặt trang"),
        ),
        body: _buildBody());
  }

  /// UI hiển thị thông tin của trang
  Widget _buildBody() {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "CHỌN TRANG FACEBOOK",
                style: TextStyle(color: Color(0xFF28A745), fontSize: 15),
                textAlign: TextAlign.left,
              ),
            ),
            _buildHeader(),
            const SizedBox(
              height: 16,
            ),
            const Divider(
              height: 1,
            ),
            _buildContent()
          ],
        ),
      ),
    );
  }

  /// UI hiển thị thông tin add thêm 1 page
  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 16, right: 12),
            width: 36,
            height: 36,
            child: const CircleAvatar()),
        const Flexible(
          child: Text(
            "QAXK Nhiên Trung",
            style: TextStyle(color: Color(0xFF2C333A), fontSize: 21),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        const Icon(
          Icons.keyboard_arrow_down_outlined,
          size: 24,
          color: Color(0xFF929DAA),
        )
      ],
    );
  }

  /// UI build thông tin  cài đặt
  Widget _buildContent() {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(
              width: 4,
            ),
            Switch.adaptive(
              value: isHideComment,
              onChanged: (value) {
                setState(() {
                  isHideComment = !isHideComment;
                });
              },
              activeColor: const Color(0xFF28A745),
            ),
            const Text("Ẩn bình luận trên Facebook"),
          ],
        ),
        if (!isHideComment)
          const SizedBox()
        else
          ...List.generate(
              settings.length,
              (index) => Row(
                    children: [
                      const SizedBox(
                        width: 48,
                      ),
                      Switch.adaptive(
                        value: isSettings[index]["key"],
                        onChanged: (value) {
                          setState(() {
                            isSettings[index]["key"] = value;
                          });
                        },
                        activeColor: const Color(0xFF28A745),
                      ),
                      Text(settings[index])
                    ],
                  )),
        _buildKeyWord()
      ],
    );
  }

  /// UI hiển  thị thong tin các Keywword đã add
  Widget _buildKeyWord() {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 4, bottom: 16),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE9EDF2))),
      child: Column(
        children: [
          Wrap(
            children: [
              ...List.generate(
                  keyWords.length,
                  (index) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 6),
                        margin: const EdgeInsets.only(right: 6, bottom: 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: const Color(0xFFF0F1F3)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Mua hàng",
                              style: TextStyle(
                                  color: Color(0xFF2C333A), fontSize: 13),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  keyWords.removeAt(index);
                                });
                              },
                              child: Container(
                                width: 24,
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Color(0xFF929DAA),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: _keyController,
                  decoration: const InputDecoration.collapsed(
                      hintText: "Nhập từ khóa",
                      hintStyle:
                          TextStyle(color: Color(0xFF929DAA), fontSize: 14)),
                ),
              ),
            ],
          ),
          Visibility(
              visible: _keyController.text != "",
              child: InkWell(
                onTap: () {
                  setState(() {
                    keyWords.add(_keyController.text);
                    _keyController.text = "";
                  });
                },
                child: Container(
                    margin: const EdgeInsets.only(top: 6),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF0F1F3),
                        borderRadius: BorderRadius.circular(3)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Text(_keyController.text)),
              ))
        ],
      ),
    );
  }
}
