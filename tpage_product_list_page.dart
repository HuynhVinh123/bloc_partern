import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'item_product.dart';

class TPageProductListPage extends StatefulWidget {
  @override
  _TPageProductListPageState createState() => _TPageProductListPageState();
}

class _TPageProductListPageState extends State<TPageProductListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEDEF),
      appBar: AppBar(),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children:const [
              Expanded(
                child:    Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    "SẢN PHẨM",
                    style: TextStyle(color: Color(0xFF28A745), fontSize: 15),
                  ),
                ),
              ),
              Expanded(
                child:    Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    "THÊM VÀO PAGE",
                    style: TextStyle(color: Color(0xFF28A745), fontSize: 15),
                  ),
                ),
              )
            ],),
            Expanded(child: _buildListProduct(),)
          ],
        ),
      ),
    );
  }

  Widget _buildListProduct(){
    return ListView.builder(itemCount: 5,itemBuilder: (context,index){
      return ItemProduct();
    });
  }

}
