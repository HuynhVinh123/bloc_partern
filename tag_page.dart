import 'package:flutter/material.dart';
import 'package:tpos_mobile/feature_group/tpage/uis/item_tag.dart';

class TagPage extends StatefulWidget {
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  List<String> tags = ["tag1", "tag2"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(),
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 8,),
          Flexible(child: _buildTags()),
        ],
      ),
    );
  }

  Widget _buildButtonAddTag() {
    return Container(
      margin: const EdgeInsets.only(left: 42),
      child: FlatButton.icon(
          onPressed: () {},
          icon: const Icon(
            Icons.add,
            color: Color(0xFF28A745),
          ),
          label: const Text(
            "Thêm nhãn mới",
            style: TextStyle(color: Color(0xFF28A745)),
          )),
    );
  }

  Widget _buildTags() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Text("NHÃN HỘI THOẠI (4)",style: TextStyle(color: const Color(0xFF28A745),fontSize: 15),),
          ),
          ...List.generate(
              tags.length,
              (index) => ItemTag(
                    stateColor: Color(0xFF28A745),
                    stateText: "Đang sử dụng",
                    title: "Đã lên đơn",
                    backGroundColor: const Color(0xFF28A745),
                    actions: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 24,
                            height: 24,
                            child: const Icon(
                              Icons.edit,
                              size: 19,
                              color: Color(0xFFA7B2BF),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            width: 24,
                            height: 24,
                            child: const Icon(
                              Icons.delete,
                              size: 19,
                              color: Color(0xFFA7B2BF),
                            ),
                          ),
                        )
                      ],
                    ),
                  )),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(),
          ),
          _buildButtonAddTag()
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Switch.adaptive(
            value: true,
            onChanged: (value) {},
            activeColor: const Color(0xFF28A745),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Tự động gắn nhãn vào hội thoại có chứa Số điện thoại",
                style: TextStyle(color: Color(0xFF2C333A)),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                "Chọn nhãn",
                style: TextStyle(
                    color: Color(0xFF2C333A),
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(right: 16, top: 10),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFDFE7EC)),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    Expanded(
                      child: Wrap(
                          children: tags
                              .map((e) => const Padding(
                                    padding:
                                        EdgeInsets.only(right: 4, bottom: 4),
                                    child: Chip(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 6),
                                      // selected: false,
                                      label: Text(
                                        "Mua hàng",
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      backgroundColor: Color(0xFF0DA898),
//                         selectedColor: Color(0xFF0DA898),
                                    ),
                                  ))
                              .toList()),
                    ),
                    const Icon(Icons.arrow_drop_down)
                  ],
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}
