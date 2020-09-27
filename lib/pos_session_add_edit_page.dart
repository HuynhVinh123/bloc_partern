import 'package:flutter/material.dart';
import 'package:tpos_mobile/widgets/my_step_view.dart';

class PosSessionAddEditPage extends StatefulWidget {
  @override
  _PosSessionAddEditPageState createState() => _PosSessionAddEditPageState();
}

class _PosSessionAddEditPageState extends State<PosSessionAddEditPage> {
  TextStyle detailFontStyle;
  TextStyle titleFontStyle;
  Widget spaceHeight = const SizedBox(
    height: 10,
  );

  @override
  Widget build(BuildContext context) {
    titleFontStyle = const TextStyle(color: Colors.green);
    detailFontStyle = const TextStyle(color: Colors.green);

    return Scaffold(
        backgroundColor: const Color(0xFFEBEDEF),
        appBar: AppBar(
          title: const Text("Phiên bán"),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 60),
            child: Container(
              child: _buildInfoPointSale(),
            ),
          ),
          Positioned(
            bottom: 6,
            child: _buildButtonClosePointSale(),
          )
        ],
      ),
    );
  }

  Widget _buildButtonClosePointSale() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        color: Colors.grey[400])
                  ],
                  color: const Color(0xFF89919A),
                  borderRadius: BorderRadius.circular(6)),
              child: RaisedButton(
                color: const Color(0xFF89919A),
                onPressed: () async {
                  // final dialogResult = await showQuestion(
                  //     context: context,
                  //     title: "Xác nhận đóng",
                  //     message: "Bạn có muốn đóng phiên bán hàng");
                  //
                  // if (dialogResult == DialogResultType.YES) {
                  //   await _vm.handleClosePosSession(context, widget.id);
                  // }
                },
                child: const Center(
                  child: Text("Kết thúc phiên",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 18,
          ),
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 2),
                        blurRadius: 2,
                        color: Colors.grey[400])
                  ],
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(6)),
              child: RaisedButton(
                onPressed: () async {},
                child: const Center(
                  child: Text("Tiếp tục",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPointSale() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _step(),
          const SizedBox(
            height: 12,
          ),
          _buildInfoGeneral(),
          spaceHeight,
          spaceHeight,
          _buildPaymentType()
        ],
      ),
    ));
  }

  Widget _buildPaymentType() {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 12),
            child: Text(
              "PHƯƠNG THỨC THANH TOÁN",
              style: titleFontStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          spaceHeight,

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _showItemAccountBank(),
              );
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
                height: 1,
              );
            },
            itemCount: 1,
          ),
          spaceHeight,
        ],
      ),
    );
  }

  Widget _showItemAccountBank() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: ExpansionTile(
        title: const Text(
            "Tiền mặt",
            style: TextStyle(color: Colors.black),
          ),
        initiallyExpanded: true,
        backgroundColor: const Color(0xFFF0F1F3),
        children: <Widget>[
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Số dư bắt đầu:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("125.000.325",
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.w700)),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Giao dịch:",
            ),
            content: Text("125.000.325",
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54))),
          ),
          const Divider(
            height: 1,
          ),
           InRow(
              contentTextStyle: titleFontStyle,
              title: const Text(
                "Số dư kết thúc lí thuyết:",
              ),
              content: Text("125.000.325",
                  textAlign: TextAlign.right,
                  style: detailFontStyle.copyWith(
                      color: const Color(0xFF484D54))),
            ),

          const Divider(
            height: 1,
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Số dư kết thúc thực tế:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("125.000.325",
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54))),
          ),
          const Divider(
            height: 1,
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Chênh lệch:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("125.000.325",
                textAlign: TextAlign.right,
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54),
                    fontWeight: FontWeight.w700)),
          ),
          InRow(
            content: Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(0xFFF0F1F3),
                      borderRadius: BorderRadius.circular(3)),
                  width: 75,
                  height: 30,
                  child: const Center(
                    child: Text("Chi tiết"),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInfoGeneral() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          InRow(
            title: const Text(
              "TỔNG QUAN",
              style: TextStyle(
                  color: Color(0xFF28A745),
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Phiên bán hàng: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("",
                style: detailFontStyle.copyWith(
                    color: const Color(0xFF484D54), fontSize: 16)),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Chịu trách nhiệm: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("",
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Điểm bán hàng: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("",
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Ngày bắt đầu: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("",
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          ),
          InRow(
            contentTextStyle: titleFontStyle,
            title: const Text(
              "Ngày kết thúc: ",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            content: Text("",
                style:
                    detailFontStyle.copyWith(color: const Color(0xFF484D54))),
          )
        ],
      ),
    );
  }

  Widget _step() {
    return MyStepView(
      currentIndex: 2,
      items: [
        MyStepItem(
          title: const Text(
            "Nháp",
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: true,
        ),
        MyStepItem(
          title: const Text(
            "Xác nhận",
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: true,
        ),
        MyStepItem(
          title: const Text(
            "Thanh toán",
            textAlign: TextAlign.center,
          ),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          lineColor: Colors.red,
          isCompleted: false,
        ),
        MyStepItem(
            title: const Text(
              "Hoàn thành",
              textAlign: TextAlign.center,
            ),
            icon: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            lineColor: Colors.red,
            isCompleted: false),
      ],
    );
  }
}
class InRow extends StatelessWidget {
  final Widget title;
  final Widget content;
  final String titleString;
  final String contentString;
  final EdgeInsetsGeometry padding;
  final Color titleColor;
  final Color contentColor;
  final TextStyle contentTextStyle;
  InRow({
    this.title,
    this.content,
    this.padding =
    const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
    this.contentString,
    this.titleString,
    this.titleColor = Colors.black,
    this.contentColor = Colors.green,
    this.contentTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            title ??
                (new Text(
                  titleString ?? "",
                  style: TextStyle(color: titleColor),
                )),
            Expanded(
              child: content ??
                  (new Text(
                    contentString ?? "",
                    style:
                    contentTextStyle ?? new TextStyle(color: contentColor),
                    textAlign: TextAlign.right,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}