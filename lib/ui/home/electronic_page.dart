import 'package:flutter/material.dart';

class ElectronicPage extends StatefulWidget {
  @override
  _ElectronicPageState createState() => _ElectronicPageState();
}

class _ElectronicPageState extends State<ElectronicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Thương hiệu lớn",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 280,
              child: GridView.builder(
                  itemCount: 19,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8,top: 4,bottom: 4),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          width: 60,
                          height: 80,
                          child: Center(child: Text("1"))),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Top điện thoại và máy tính bảng",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(itemCount: 10,scrollDirection: Axis.horizontal,itemBuilder: (BuildContext context,int index){
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)),
                      width: 90,
                      height: 120,
                      child: Center(child: Text("1"))),
                );
              }),
            ),Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Phụ kiện",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 280,
              child: GridView.builder(
                  itemCount: 19,
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8,top: 4,bottom: 4),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          width: 60,
                          height: 80,
                          child: Center(child: Text("1"))),
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Top phụ kiện",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              height: 120,
              child: ListView.builder(itemCount: 10,scrollDirection: Axis.horizontal,itemBuilder: (BuildContext context,int index){
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey)),
                      width: 90,
                      height: 120,
                      child: Center(child: Text("1"))),
                );
              }),
            ),
            SizedBox(height: 12,)
          ]),
        )
      ]),
    );
  }



}
