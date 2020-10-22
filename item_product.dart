import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemProduct extends StatefulWidget {
  @override
  _ItemProductState createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  @override
  Widget build(BuildContext context) {
    return   ListTile(
        onTap:  () {},
        leading: Container(
          height: 50  ,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(13))),
          child: Image.asset("images/no_image.png",fit: BoxFit.fill,),
        ),
        title: Text("[SP0025] Combo 3 chén sành",style: TextStyle(color: Color(0xFF2C333A)),),
        subtitle:  RichText(
          text: TextSpan(
            text: 'Hello ',
            style: DefaultTextStyle.of(context).style,
            children:const <TextSpan>[
              TextSpan(text: 'Cái - ', style: TextStyle(color: Color(0xFF929DAA))),
              TextSpan(text: "SL thực:",style: TextStyle(color: Color(0xFF929DAA))),
              TextSpan(text: '200',style: TextStyle(color: Color(0xFF28A745))),
              TextSpan(text: ' - ', style: TextStyle(color: Color(0xFF929DAA))),
              TextSpan(text: '200.000', style: TextStyle(color: Color(0xFF6B7280),fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        trailing: Switch.adaptive(value: true, onChanged: (value){},activeColor: const Color(0xFF28A745),)
    );
  }
}
