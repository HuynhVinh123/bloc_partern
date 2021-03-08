import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';
import 'package:tpos_mobile/feature_group/pos_order/models/payment.dart';
import 'package:tpos_mobile_localization/tpos_mobile_localization.dart';

class PosCartEditProductPage extends StatefulWidget {
  const PosCartEditProductPage(this.item);
  final Lines item;
  @override
  _PosCartEditProductPageState createState() => _PosCartEditProductPageState();
}

class _PosCartEditProductPageState extends State<PosCartEditProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        /// Sửa thông tin sản phẩm
        title: Text(S.current.posOfSale_editProduct),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: <Widget>[
          const SizedBox(
            height: 6,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: <Widget>[
                Container(
                    height: 60,
                    width: 60,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(6)),
                    child: widget.item.image == null
                        ? Image.asset("images/no_image.png")
                        : Image.network(
                            "${widget.item.image} ",
                          )),
                const SizedBox(
                  width: 6,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(" ${widget.item.productName ?? ""}"),

                      /// Đơn vị
                      Text("${S.current.unit}: ${widget.item.uomName ?? ""}"),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(

                  /// Số lương
                  child: Text(
                "${S.current.posOfSale_quantity}:",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 150,
                child: TextField(
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(hintText: "0"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      NumberInputFormat.vietnameDong(),
                    ]),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "${S.current.posOfSale_price}:",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 150,
                child: TextField(
                  textAlign: TextAlign.end,
                  decoration: const InputDecoration(
                      hintText: "0",
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFEBEDEF)))),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    NumberInputFormat.vietnameDong(),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Text(
                "${S.current.posOfSale_discount}:",
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              )),
              const SizedBox(
                width: 8,
              ),
              Container(
                width: 150,
                child: TextField(
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(hintText: "0"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      NumberInputFormat.vietnameDong(),
                    ]),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          TextField(
            decoration: InputDecoration(
                hintText: S.current.posOfSale_notes,
                prefixIcon: const Icon(
                  Icons.event_note,
                  color: Color(0xFF28A745),
                )),
          )
        ],
      ),
    );
  }
}
