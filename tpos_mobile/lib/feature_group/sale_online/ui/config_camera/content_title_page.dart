import 'package:flutter/material.dart';

class ContentTitlePage extends StatelessWidget {
  ContentTitlePage({this.content, this.isTitle = false});
  final String content;
  final bool isTitle;

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _contentController.text = content;
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0.1,
          leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 18,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pop(
                  context,
                );
              }),
          title: Center(
            child: Text(isTitle ? 'Tiêu đề' : 'Nội dung',
                style: TextStyle(color: Colors.grey[700], fontSize: 15)),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save, color: Colors.grey),
              onPressed: () {
                Navigator.pop(context, _contentController.text);
              },
            )
          ],
          backgroundColor: Colors.white,
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[300]),
              borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: _contentController,
            minLines: isTitle ? 1 : 3,
            maxLines: null,
            decoration: InputDecoration.collapsed(
                hintText: isTitle ? 'Nhập tiêu đề ... ' : 'Nhập nội dung ... ',
                hintStyle: const TextStyle(fontSize: 14)),
          ),
        ));
  }
}
