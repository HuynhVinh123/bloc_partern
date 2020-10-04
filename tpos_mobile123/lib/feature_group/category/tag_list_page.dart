import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class TagListPage extends StatefulWidget {
  TagListPage({this.tags});
  final List<Tag> tags;

  @override
  _TagListPageState createState() => _TagListPageState();
}

class _TagListPageState extends State<TagListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách Tag"),
      ),
      body: ListView.separated(
        itemCount: widget.tags.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.pop(context, widget.tags[index]);
            },
            title: InkWell(
                child: Text(
              widget.tags[index].name,
            )),
          );
        },
      ),
    );
  }
}
