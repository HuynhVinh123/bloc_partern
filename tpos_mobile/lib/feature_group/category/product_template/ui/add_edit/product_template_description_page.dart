import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

///TODO(sangcv): màn hình nhập có keyboard style
///Màn hình nhập mô tả sản phẩm
class ProductTemplateDescriptionPage extends StatefulWidget {
  const ProductTemplateDescriptionPage({Key key, this.description = ''}) : super(key: key);

  @override
  _ProductTemplateDescriptionPageState createState() => _ProductTemplateDescriptionPageState();
  final String description;
}

class _ProductTemplateDescriptionPageState extends State<ProductTemplateDescriptionPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.text = widget.description;
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }


  Widget _buildAppbar() {
    return AppBar(
      leading: IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      title: Text(
        S.of(context).productDescription,
        style: const TextStyle(color: Colors.white, fontSize: 21),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.check, color: Colors.white, size: 30),
            onPressed: () {
              Navigator.pop(context, _descriptionController.text);
            }),
      ],
    );
  }

  Widget _buildBody() {

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).productDescription.toUpperCase(),
              style: const TextStyle(fontSize: 15, color: Color(0xff28A745))),
          Expanded(
            child: TextField(
              controller: _descriptionController,
              autofocus: true,
              style: const TextStyle(color: Color(0xff2C333A), fontSize: 17),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration:  InputDecoration(
                  contentPadding: const EdgeInsets.only(right: 10, left: 5, bottom: 5),
                  enabledBorder: InputBorder.none,
                  hintText: S.of(context).selectParam(S.of(context).description.toLowerCase()),
                  hintStyle: const TextStyle(color: Color(0xff929DAA), fontSize: 17),
                  focusedBorder: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }
}
