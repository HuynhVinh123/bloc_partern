import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/app_core/helper/string_helper.dart';

class ItemProduct extends StatelessWidget {
  const ItemProduct(
      {this.onPress, this.onChangeSelected, this.productTPageInfo});

  final VoidCallback onPress;
  final ValueChanged<bool> onChangeSelected;
  final ProductTPageInfo productTPageInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: const EdgeInsets.all(0),
        onTap: onPress ?? () {},
        leading: Container(
          margin: const EdgeInsets.only(left: 16),
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(13))),
          child: productTPageInfo.imageUrl != null && productTPageInfo.imageUrl != ""
              ? Image.network(productTPageInfo.imageUrl, fit: BoxFit.fill)
              : Image.asset(
                  "images/no_image.png",
                  fit: BoxFit.fill,
                ),
        ),
        title: Text(
          productTPageInfo.nameGet ?? "",
          style: const TextStyle(color: Color(0xFF2C333A)),
        ),
        subtitle: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  text: '${productTPageInfo.uOMName ?? ""} - ',
                  style: const TextStyle(color: Color(0xFF929DAA))),
              const TextSpan(
                  text: "SL thực: ",
                  style: TextStyle(color: Color(0xFF929DAA))),
              TextSpan(
                  text: '${productTPageInfo.qtyAvailable ?? 0}',
                  style: const TextStyle(color: Color(0xFF28A745))),
              const TextSpan(
                  text: ' - ', style: TextStyle(color: Color(0xFF929DAA))),
              TextSpan(
                  text: vietnameseCurrencyFormat(productTPageInfo.price ?? 0),
                  style: const TextStyle(
                      color: Color(0xFF6B7280), fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Switch.adaptive(
            value: productTPageInfo.isAvailableOnTPage,
            onChanged: onChangeSelected ?? (value) {},
            activeColor: const Color(0xFF28A745),
          ),
        ));
  }
}
