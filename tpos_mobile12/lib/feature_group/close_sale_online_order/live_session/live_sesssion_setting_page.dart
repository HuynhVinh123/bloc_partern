import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/feature_group/category/product_search_page.dart';
import 'package:tpos_mobile/feature_group/close_sale_online_order/models/comment_setting.dart';
import 'package:tpos_mobile/feature_group/sale_online/ui/sale_online_live_campaign_select_page.dart';
import 'package:tpos_mobile/src/tpos_apis/models/live_campaign.dart';

class LiveSessionConfigPage extends StatefulWidget {
  const LiveSessionConfigPage({Key key, this.commentSetting}) : super(key: key);
  final CommentSetting commentSetting;

  @override
  _LiveSessionConfigPageState createState() => _LiveSessionConfigPageState();
}

class _LiveSessionConfigPageState extends State<LiveSessionConfigPage> {
  final TextEditingController _quantityController = TextEditingController();

  final TextEditingController _keyWordOnAppController = TextEditingController();

  final List<FocusNode> _keyWordAutoCreateInvoiceFocuss = <FocusNode>[];

  /// TEST
  final List<String> _items = <String>["Mua hàng", "Mua"];
  final List<String> _itemsKeyAutoCreateInvoice = <String>[];
  final List<String> _itemAutoCreateInvoices = <String>[];
  final List<TextEditingController> _autoCreateInvoicesController =
      <TextEditingController>[];
  MediaQueryData queryData;

  /// TEST nội dung mẫu
  bool _isAutoCreateInvoice = false;
  bool _isCreateInvoiceWitPhone = false;
  bool _isCreateInvoiceWitMultiPhone = false;

  @override
  void initState() {
    super.initState();
    _isAutoCreateInvoice = false;
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  // UI hiển thị appbar
  Widget _buildAppbar() => AppBar(
        title: const Text('Thiết lập cấu hình'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      );

  // UI tổng quát
  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            bottom: 60,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                _buildOption(),
                _buildLiveCampaign(),
                _HideCommentOnFacebook(
                  hideCommentSetting:
                      widget.commentSetting.hideCommentOnFacebookSetting,
                ),
                _buildHideCommentOnApp(),
                _buildAutoCreateInvoice(),
                _buildPrint(),
              ]),
            ),
          ),
          Positioned(
            bottom: 8,
            left: 12,
            right: 12,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: const Color(0xFFDCE2E5),
                        borderRadius: BorderRadius.circular(6)),
                    child: FlatButton(
                      onPressed: () {},
                      child: const Text(
                        "Đóng",
                        style: TextStyle(color: Color(0xFF2C333A)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                        color: const Color(0xFF28A745),
                        borderRadius: BorderRadius.circular(6)),
                    child: FlatButton(
                      onPressed: () {},
                      child: const Text(
                        "Chốt đơn",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // UI chọn trang bài viết
  Widget _buildOption() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text(
          "KÊNH VÀ BÀI ĐĂNG",
          style: TextStyle(color: Color(0xFF28A745), fontSize: 14),
        ),
        children: <Widget>[
          _buildItem(),
        ],
      ),
    );
  }

  // UI item trang bài viết
  Widget _buildItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Text(
            //   widget.commentSetting.crmTeam.facebookPageName ?? '',
            //   style: const TextStyle(
            //       color: Color(0xFF484D54), fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 12,
            // ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.deepOrange, width: 3),
                              shape: BoxShape.circle),
                          width: 36,
                          height: 36,
                          child: CircleAvatar(
                            backgroundColor: Colors.green,
                          )),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange, shape: BoxShape.circle),
                          child: Center(
                            child: const Icon(
                              Icons.videocam,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Text(
                      widget.commentSetting.crmTeam.facebookPageName ?? '',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(widget.commentSetting.facebookPost.message ?? ''),
                ),
                const SizedBox(
                  width: 10,
                ),
                Container(
                  width: 100,
                  height: 65,
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Center(
                    child: Image.network(
                      widget.commentSetting.facebookPost.picture,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  // UI khi trang bài viết rỗng
  Widget _buildEmpty() {
    return Column(
      children: <Widget>[
        Image.asset(
          "images/ic_facebook.png",
          width: 32,
          height: 32,
        ),
        const Padding(
          padding: EdgeInsets.only(left: 28, right: 28, top: 10),
          child: Text(
            "Chưa có bài viết nào. Chọn bài LiveStream hoặc bài viết bạn muốn thêm vào phiên.",
            textAlign: TextAlign.center,
            style: TextStyle(color: const Color(0xFF929DAA)),
          ),
        ),
        const SizedBox(
          height: 27,
        ),
        Row(
          children: <Widget>[
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: const Text(
              "Trang facebook",
              style: const TextStyle(
                  color: Color(0xFF484D54), fontWeight: FontWeight.bold),
            )),
            const Text(
              "Chọn trang",
              style: const TextStyle(color: const Color(0xFF929DAA)),
            ),
            const SizedBox(
              width: 6,
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF929DAA),
              size: 11,
            ),
            const SizedBox(
              width: 16,
            ),
          ],
        ),
        const SizedBox(
          height: 14,
        )
      ],
    );
  }

  // UI chiến dịch live
  Widget _buildLiveCampaign() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: const Text(
          "CHIẾN DỊCH LIVE",
          style: TextStyle(color: Color(0xFF28A745), fontSize: 14),
        ),
        children: <Widget>[
          InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  const Expanded(
                      child: Text(
                    "Chiến dịch live",
                    style: TextStyle(
                        color: Color(0xFF484D54), fontWeight: FontWeight.bold),
                  )),
                  if (widget.commentSetting.liveCampaign != null)
                    Text(
                      widget.commentSetting.liveCampaign.name ?? '',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )
                  else
                    const Text(
                      "Chọn chiến dịch",
                      style: TextStyle(
                        color: const Color(0xFF929DAA),
                        fontSize: 16,
                      ),
                    ),
                  const SizedBox(
                    width: 6,
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF929DAA),
                    size: 11,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                ],
              ),
            ),
            onTap: () async {
              final LiveCampaign liveCampaign = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SaleOnlineLiveCampaignSelectPage();
                  },
                ),
              );

              if (liveCampaign != null) {
                setState(() {
                  widget.commentSetting.liveCampaign = liveCampaign;
                });
              }
            },
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _buildHideCommentOnApp() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "ẨN BÌNH LUẬN TRÊN ỨNG DỤNG",
          style: const TextStyle(color: Color(0xFF28A745), fontSize: 14),
        ),
        children: <Widget>[
          const SizedBox(
            height: 16,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  // UI chứa từ khóa ẩn Facebook

  // UI chứa từ khóa ẩn ứng dụng
  // Widget _keyListHideApp() {
  //   return InkWell(
  //     onTap: () {
  //       _keyWordOnAppFocus.requestFocus();
  //     },
  //     child: Container(
  //       decoration: BoxDecoration(
  //           border: Border.all(color: const Color(0xFFDFE7EC)),
  //           borderRadius: BorderRadius.circular(4)),
  //       margin: const EdgeInsets.only(left: 16, right: 16),
  //       padding: EdgeInsets.symmetric(
  //           horizontal: 6, vertical: _items.length == 0 ? 24 : 4),
  //       width: double.infinity,
  //       child: Wrap(
  //         children: [
  //           ...List.generate(_items.length,
  //               (int index) => _itemKeyCommentApp(index, _items[index])),
  //           _itemKeyCommentApp(_items.length, "Thêm từ khóa")
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // UI từ khóa ẩn bình luận trên ứng dụng
  // Widget _itemKeyCommentApp(int index, String name) {
  //   return index > _items.length - 1
  //       ? Column(
  //           children: <Widget>[
  //             TextField(
  //               onChanged: (value) {
  //                 setState(() {});
  //               },
  //               onSubmitted: (value) {
  //                 setState(() {
  //                   if (value != "") {
  //                     _items.add(value);
  //                     _keyWordOnAppController.text = "";
  //                   }
  //                 });
  //               },
  //               controller: _keyWordOnAppController,
  //               decoration: InputDecoration.collapsed(
  //                   hintText: "$name",
  //                   hintStyle: const TextStyle(fontSize: 14)),
  //               focusNode: _keyWordOnAppFocus,
  //             ),
  //             Visibility(
  //               visible: _keyWordOnAppController.text != "",
  //               child: Align(
  //                   alignment: Alignment.topCenter,
  //                   child: Container(
  //                     height: 30,
  //                     decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         boxShadow: [
  //                           BoxShadow(
  //                               offset: Offset(-2, 2),
  //                               color: const Color(0xFFEBEDEF),
  //                               blurRadius: 2)
  //                         ]),
  //                     child: FlatButton.icon(
  //                         onPressed: () {
  //                           setState(() {
  //                             if (_keyWordOnAppController.text != "") {
  //                               _items.add(_keyWordOnAppController.text);
  //                               _keyWordOnAppController.text = "";
  //                             }
  //                           });
  //                         },
  //                         icon: Icon(
  //                           Icons.add,
  //                           size: 18,
  //                           color: Colors.grey,
  //                         ),
  //                         label: Text("${_keyWordOnAppController.text}")),
  //                   )),
  //             )
  //           ],
  //         )
  //       : InkWell(
  //           onTap: () {},
  //           child: Container(
  //             margin: const EdgeInsets.only(right: 10, bottom: 10),
  //             padding: const EdgeInsets.only(left: 10),
  //             height: 32,
  //             decoration: BoxDecoration(
  //                 color: const Color(0xFFF0F1F3),
  //                 borderRadius: BorderRadius.circular(4)),
  //             child: Row(
  //               mainAxisSize: MainAxisSize.min,
  //               children: <Widget>[
  //                 Text(name),
  //                 IconButton(
  //                   icon: Icon(
  //                     Icons.close,
  //                     size: 18,
  //                     color: const Color(0xFF484D54),
  //                   ),
  //                   onPressed: () {
  //                     setState(() {
  //                       _items.removeAt(index);
  //                     });
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  // }

  // UI hiển thị tự động tạo đơn hàng
  Widget _buildAutoCreateInvoice() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "TỰ ĐỘNG TẠO ĐƠN HÀNG",
          style: const TextStyle(color: Color(0xFF28A745), fontSize: 14),
        ),
        children: <Widget>[
          _buildSwitchAutoCreateInvoice(),
          ...List.generate(_itemAutoCreateInvoices.length,
              (index) => _buildItemContentBasic(index)),
          const SizedBox(
            height: 24,
          ),
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F1F3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: FlatButton.icon(
                onPressed: () {
                  setState(() {
                    _itemAutoCreateInvoices.add("");
                    _autoCreateInvoicesController.add(TextEditingController());
                    _keyWordAutoCreateInvoiceFocuss.add(FocusNode());
                  });
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.grey[600],
                ),
                label: Text(
                  "Thêm từ khóa",
                  style: const TextStyle(color: Color(0xFF484D54)),
                )),
          ),
          const SizedBox(
            height: 24,
          )
        ],
      ),
    );
  }

  // Hiển thị UI các nội dung comment không chứa nội dung
  Widget _buildContentCommentNoHas() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Bình luận không chứa nội dung:",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 4,
            ),
            _textFieldComment(),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  "Chỉ bình luận có độ dài lớn hơn ${_quantityController.text == "" ? 0 : _quantityController.text} ký tự:",
                  style: const TextStyle(fontSize: 16),
                )),
                const SizedBox(
                  width: 12,
                ),
//                Container(
//                  width: 120,
//                  height: 45,
//                  child: TextField(
//                    controller: _quantityController,
//                    decoration: InputDecoration(hintText: "Số lượng"),
//                    onChanged: (value) {
//                      setState(() {
//                        _quantityController.text = value;
//                      });
//                    },
//                    textAlign: TextAlign.right,
//                    keyboardType: TextInputType.number,
//                    inputFormatters: <TextInputFormatter>[
//                      WhitelistingTextInputFormatter.digitsOnly,
//                    ],
//                  ),
//                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // UI hiển thị Item nội dung mẫu bảng design
  Widget _buildItemContentBasic(int indexInvoiceBasic) {
    return ListTile(
      title: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDFE7EC)),
            borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                _keyWordAutoCreateInvoiceFocuss[indexInvoiceBasic]
                    .requestFocus();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: _itemsKeyAutoCreateInvoice.length == 0 ? 24 : 4),
                width: double.infinity,
                child: Wrap(
                  children: [
                    ...List.generate(
                        _itemsKeyAutoCreateInvoice.length,
                        (int index) => _itemKeyAutoCreateInvoice(
                            index,
                            _itemsKeyAutoCreateInvoice[index],
                            indexInvoiceBasic)),
                    _itemKeyAutoCreateInvoice(_itemsKeyAutoCreateInvoice.length,
                        "Thêm từ khóa", indexInvoiceBasic)
                  ],
                ),
              ),
            ),
            Divider(
              color: const Color(0xFFDFE7EC),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10, left: 12),
                  width: 37,
                  height: 37,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6)),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Áo thun 20k",
                              style: const TextStyle(
                                  color: Color(0xFF2C333A), fontSize: 16),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductSearchPage(),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                const Text(
                                  "Đổi SP khác",
                                  style: TextStyle(
                                      color: const Color(0xFF929DAA),
                                      fontSize: 15),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: const Color(0xFF929DAA),
                                  size: 11,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "Cái | 20000đ",
                        style: const TextStyle(
                            color: Color(0xFF929DAA), fontSize: 14),
                      ),
                      const SizedBox(
                        height: 6,
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      subtitle: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductSearchPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.business_center,
                        color: Color(0xFF28A745),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        "Chọn sản phẩm",
                        style: const TextStyle(color: Color(0xFF28A745)),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    _itemAutoCreateInvoices.removeAt(indexInvoiceBasic);
                    _autoCreateInvoicesController[indexInvoiceBasic].text = "";
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.close,
                      color: Color(0xFFF33240),
                      size: 20,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      "Xóa",
                      style: const TextStyle(color: Color(0xFFF33240)),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// UI hiển thị các key của item nội dung bảng mẩu
  Widget _itemKeyAutoCreateInvoice(
      int index, String name, int indexInvoiceBasic) {
    return index > _itemsKeyAutoCreateInvoice.length - 1
        ? Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  setState(() {
                    if (value != "") {
                      _itemsKeyAutoCreateInvoice.add(value);
                      _autoCreateInvoicesController[indexInvoiceBasic].text =
                          "";
                    }
                  });
                },
                controller: _autoCreateInvoicesController[indexInvoiceBasic],
                decoration: InputDecoration.collapsed(
                    hintText: "$name",
                    hintStyle: const TextStyle(fontSize: 14)),
                focusNode: _keyWordAutoCreateInvoiceFocuss[indexInvoiceBasic],
//                expands: true,
//                minLines: null,
//                maxLines: null,
              ),
              Visibility(
                visible:
                    _autoCreateInvoicesController[indexInvoiceBasic].text != "",
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(-2, 2),
                                color: const Color(0xFFEBEDEF),
                                blurRadius: 2)
                          ]),
                      child: FlatButton.icon(
                          onPressed: () {
                            setState(() {
                              if (_autoCreateInvoicesController[
                                          indexInvoiceBasic]
                                      .text !=
                                  "") {
                                _itemsKeyAutoCreateInvoice.add(
                                    _autoCreateInvoicesController[
                                            indexInvoiceBasic]
                                        .text);
                                _autoCreateInvoicesController[indexInvoiceBasic]
                                    .text = "";
                              }
                            });
                          },
                          icon: Icon(Icons.add, size: 18, color: Colors.grey),
                          label: Text(
                              "${_autoCreateInvoicesController[indexInvoiceBasic].text}")),
                    )),
              )
            ],
          )
        : InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10),
              height: 32,
              decoration: BoxDecoration(
                  color: const Color(0xFFF0F1F3),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("$name"),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: const Color(0xFF484D54),
                    ),
                    onPressed: () {
                      setState(() {
                        _itemsKeyAutoCreateInvoice.removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
  }

  // UI hiển thị in phiếu
  Widget _buildPrint() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "IN PHIẾU",
          style: const TextStyle(color: Color(0xFF28A745), fontSize: 14),
        ),
        children: <Widget>[
          Row(
            children: <Widget>[
              const SizedBox(
                width: 16,
              ),
              Expanded(
                  child: const Text(
                "Tên máy in",
                style: TextStyle(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.bold),
              )),
              const Text(
                "TPOS printer",
                style: TextStyle(color: const Color(0xFF929DAA)),
              ),
              const SizedBox(
                width: 6,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF929DAA),
                size: 11,
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: const Text(
                  "Mẫu in",
                  style: TextStyle(
                      color: const Color(0xFF484D54),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.centerRight,
                    child: _dropDownOptionPrint()),
              ),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  // UI hiển thì dropdown lựa chọn các loại máy in
  DropdownButton _dropDownOptionPrint() => DropdownButton<String>(
        items: [
          DropdownMenuItem(
            value: "1",
            child: Text(
              "Bill 80",
            ),
          ),
          DropdownMenuItem(
            value: "2",
            child: Text(
              "Bill 50",
            ),
          ),
        ],
        onChanged: (value) {},
        value: "1",
        isExpanded: true,
      );

  // Form nhập bình luận
  Widget _textFieldComment() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFDFE7EC)),
          borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: TextField(
        decoration:
            InputDecoration.collapsed(hintText: "Nội dung cách nhau dấu ,"),
        maxLines: 4,
      ),
    );
  }

  // UI swich tự động tạo đơn hàng
  // Hiển thị switch
  Widget _buildSwitchAutoCreateInvoice() {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 6,
        ),
        Switch(
          value: _isAutoCreateInvoice,
          onChanged: (value) {
            setState(() {
              _isAutoCreateInvoice = value;
            });
          },
          activeTrackColor: const Color(0xFF28A745).withOpacity(0.4),
          activeColor: const Color(0xFF28A745),
        ),
        Expanded(
          child: Text(
            "Bật tạo đơn tự động",
            style: TextStyle(color: const Color(0xFF2C333A)),
          ),
        )
      ],
    );
  }

  // Hiển thị switch cho cưỡng bức với số điện thoại
  Widget _buildSwitchCreateInvoiceWithPhone() {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 50,
        ),
        Switch(
          value: _isCreateInvoiceWitPhone,
          onChanged: (value) {
            setState(() {
              _isCreateInvoiceWitPhone = value;
            });
          },
          activeTrackColor: const Color(0xFF28A745).withOpacity(0.4),
          activeColor: const Color(0xFF28A745),
        ),
        Expanded(
          child: Text(
            "Cưỡng bức tạo đơn với số điện thoại?",
            style: TextStyle(color: const Color(0xFF2C333A)),
          ),
        )
      ],
    );
  }

  // Hiển thị switch cho cưỡng bức với nhiều số điện thoại
  Widget _buildSwitchCreateInvoiceWithMultiPhone() {
    return Row(
      children: <Widget>[
        const SizedBox(
          width: 50,
        ),
        Switch(
          value: _isCreateInvoiceWitMultiPhone,
          onChanged: (value) {
            setState(() {
              _isCreateInvoiceWitMultiPhone = value;
            });
          },
          activeTrackColor: const Color(0xFF28A745).withOpacity(0.4),
          activeColor: const Color(0xFF28A745),
        ),
        Expanded(
          child: Text(
            "Cưỡng bức tạo đơn với số nhiều điện thoại?",
            style: TextStyle(color: const Color(0xFF2C333A)),
          ),
        )
      ],
    );
  }
}

/// UI cấu hình ẩn comment trên facebook
class _HideCommentOnFacebook extends StatefulWidget {
  const _HideCommentOnFacebook(
      {Key key, this.hideCommentSetting, this.isSupported})
      : super(key: key);
  final HideCommentOnFacebookConfig hideCommentSetting;

  /// Có hỗ trợ cài đặt này hay không. Cài đặt này không khả dụng cho cá nhân
  final bool isSupported;

  @override
  __HideCommentOnFacebookState createState() => __HideCommentOnFacebookState();
}

class __HideCommentOnFacebookState extends State<_HideCommentOnFacebook> {
  final FocusNode _keyWordOnFacebookFocus = FocusNode();
  final FocusNode _keyWordOnAppFocus = FocusNode();
  final TextEditingController _keyWordOnFacebookController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      color: Colors.white,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          "ẨN BÌNH LUẬN TRÊN FACEBOOK",
          style: const TextStyle(color: Color(0xFF28A745), fontSize: 14),
        ),
        children: <Widget>[
          _HideSwitch(
            value: widget.hideCommentSetting.isHideAllComment,
            title: 'Ẩn tất cả bình luận',
            onChanged: (value) {
              setState(() {
                widget.hideCommentSetting.isHideAllComment = value;
              });
            },
          ),
          _HideSwitch(
            indent: 30,
            value: widget.hideCommentSetting.isHideCommentHasPhone,
            title: 'Ẩn bình luận có số điện thoại',
            onChanged: (value) {
              setState(() {
                widget.hideCommentSetting.isHideCommentHasPhone = value;
              });
            },
          ),
          _HideSwitch(
            indent: 30,
            value: widget.hideCommentSetting.isHideCommentHasEmail,
            title: 'Ẩn bình luận có email',
            onChanged: (value) {
              setState(() {
                widget.hideCommentSetting.isHideCommentHasEmail = value;
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          _buildHideCommentByKeyword(),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildHideCommentByKeyword() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDFE7EC)),
            borderRadius: BorderRadius.circular(4)),
        margin: const EdgeInsets.only(left: 16, right: 16),
        padding: EdgeInsets.symmetric(
            horizontal: 6,
            vertical:
                widget.hideCommentSetting.hideCommentStrings.isEmpty ? 24 : 4),
        width: double.infinity,
        child: Wrap(
          children: [
            ...List.generate(
                widget.hideCommentSetting.hideCommentStrings.length,
                (int index) => _itemKeyCommentFacebook(index,
                    widget.hideCommentSetting.hideCommentStrings[index])),
            _itemKeyCommentFacebook(
                widget.hideCommentSetting.hideCommentStrings.length,
                "Thêm từ khóa")
          ],
        ),
      ),
      onTap: () {
        _keyWordOnFacebookFocus.requestFocus();
      },
    );
  }

  // UI từ khóa ẩn bình luận trên fb
  Widget _itemKeyCommentFacebook(int index, String name) {
    return index > widget.hideCommentSetting.hideCommentStrings.length - 1
        ? Column(
            children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  if (value != "") {
                    setState(() {
                      widget.hideCommentSetting.hideCommentStrings.add(value);
                      _keyWordOnFacebookController.text = "";
                    });
                  }
                },
                controller: _keyWordOnFacebookController,
                decoration: InputDecoration.collapsed(
                  hintText: name,
                  hintStyle: const TextStyle(fontSize: 14),
                ),
                focusNode: _keyWordOnFacebookFocus,
              ),
              Visibility(
                visible: _keyWordOnFacebookController.text != "",
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 30,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(-2, 2),
                                color: Color(0xFFEBEDEF),
                                blurRadius: 2)
                          ]),
                      child: FlatButton.icon(
                        textColor: Colors.white,
                        color: Colors.green.shade400,
                        onPressed: () {
                          setState(
                            () {
                              if (_keyWordOnFacebookController.text != "") {
                                widget.hideCommentSetting.hideCommentStrings
                                    .add(_keyWordOnFacebookController.text);
                                _keyWordOnFacebookController.text = "";
                              }
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.add,
                          size: 18,
                          color: Colors.white,
                        ),
                        label: Text(_keyWordOnFacebookController.text),
                      ),
                    )),
              )
            ],
          )
        : InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              padding: const EdgeInsets.only(left: 10),
              height: 32,
              decoration: BoxDecoration(
                  color: const Color(0xFFF0F1F3),
                  borderRadius: BorderRadius.circular(4)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(name),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 18,
                      color: const Color(0xFF484D54),
                    ),
                    onPressed: () {
                      setState(() {
                        widget.hideCommentSetting.hideCommentStrings
                            .removeAt(index);
                      });
                    },
                  ),
                ],
              ),
            ),
          );
  }
}

class _HideSwitch extends StatelessWidget {
  const _HideSwitch(
      {Key key,
      @required this.value,
      this.title,
      this.subTitle,
      this.indent,
      this.onChanged})
      : super(key: key);
  final bool value;
  final String title;
  final String subTitle;
  final double indent;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: indent ?? 0,
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
        Text(title ?? ''),
      ],
    );
  }
}
