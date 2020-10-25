import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_bloc.dart';
import 'package:tpos_mobile/feature_group/tpage/settings/blocs/fast_reply/fast_reply_event.dart';

class FastReplyAddPage extends StatefulWidget {
  const FastReplyAddPage({this.bloc, this.mailTemplateTPage});
  final FastReplyBloc bloc;
  final MailTemplateTPage mailTemplateTPage;
  @override
  _FastReplyAddPageState createState() => _FastReplyAddPageState();
}

class _FastReplyAddPageState extends State<FastReplyAddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _keyboardController = TextEditingController();

  String _errorName;
  String _errorContent;

  bool _isActive;
  bool isEnableName = true;
  bool isEnableContent = true;

  @override
  void initState() {
    super.initState();
    _isActive = false;
    if (widget.mailTemplateTPage != null) {
      isEnableName = false;
      isEnableContent = false;
      _nameController.text = widget.mailTemplateTPage.name;
      _contentController.text = widget.mailTemplateTPage.bodyPlain;
      _isActive = widget.mailTemplateTPage.active;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.only(bottom: 20),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(
          width: 0,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16),
              child: Row(
                children: const [
                  Text(
                    "Thêm mới trả lời nhanh",
                    style: TextStyle(color: Color(0xFF2C333A), fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 0),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Color(0xFF929DAA),
                  )),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("Tên mẫu",
                    style: TextStyle(color: Color(0xFF929DAA), fontSize: 12)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  enabled: isEnableName,
                  controller: _nameController,
                  decoration: InputDecoration(
                      hintText: "Tên nhãn", errorText: _errorName),
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "Nội dung",
                  style: TextStyle(color: Color(0xFF929DAA), fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  enabled: isEnableContent,
                  controller: _contentController,
                  decoration: InputDecoration(
                      hintText: "Nội dung", errorText: _errorContent),
                  style: const TextStyle(color: Color(0xFF2C333A)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 18),
                child: Text(
                  "Phím tắt",
                  style: TextStyle(color: Color(0xFF2C333A), fontSize: 14),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                    left: 16, right: 16, top: 10, bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE9EDF2)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                          color: Color(0xFFF0F1F3),
                          borderRadius: BorderRadius.only()),
                      child: const Center(
                          child: Text(
                        "/",
                        style: TextStyle(color: Color(0xFF2C333A)),
                      )),
                    ),
                    Expanded(
                        child: TextField(
                      controller: _keyboardController,
                      decoration: const InputDecoration.collapsed(
                          hintText: "Nhập phím tắt"),
                      style: const TextStyle(
                          color: Color(0xFF2C333A), fontSize: 13),
                    ))
                  ],
                ),
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 4,
                  ),
                  Switch.adaptive(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = !_isActive;
                      });
                    },
                    activeColor: const Color(0xFF28A745),
                  ),
                  const Text(
                    "Kích hoạt",
                    style: TextStyle(color: Color(0xFF2C333A), fontSize: 14),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
            ]),
      ),
      actions: <Widget>[
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9EDF2)),
              borderRadius: BorderRadius.circular(5)),
          child: FlatButton(
            child: const Text(
              "Hủy",
              style: TextStyle(color: Color(0xFF5A6271)),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        Container(
          width: 120,
          height: 40,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF28A745)),
              borderRadius: BorderRadius.circular(5)),
          child: FlatButton(
            child: Text(
              widget.mailTemplateTPage != null ? "Lưu" : "Tạo mới",
              style: const TextStyle(color: Color(0xFF28A745)),
            ),
            onPressed: () async {
              if (_nameController.text != "" && _contentController.text != "") {
                Navigator.pop(context);
                if (widget.mailTemplateTPage != null) {
                  widget.bloc.add(
                      FastReplyStatusUpdated(id: widget.mailTemplateTPage.id));
                } else {
                  widget.bloc.add(FastReplyAdded(
                      mailTemplateTPage: MailTemplateTPage(
                          active: _isActive,
                          bodyPlain: _contentController.text,
                          name: _nameController.text)));
                }
              } else {
                setState(() {
                  if (_nameController.text == "") {
                    _errorName = "Tên nhãn không được để trống";
                  } else {
                    _errorName = null;
                  }
                  if (_contentController.text == "") {
                    _errorContent = "Nội dung không được để trống";
                  } else {
                    _errorContent = null;
                  }
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
