import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';
import 'package:tpos_mobile/feature_group/category/tag_list_page.dart';
import 'package:tpos_mobile/feature_group/category/viewmodel/partner_list_viewmodel.dart';

class TagPartnerListPage extends StatefulWidget {
  final List<Tag> tags;
  final List<Tag> tagPartner;
  final PartnerListViewModel viewModel;
  const TagPartnerListPage(
      {Key key, this.tags, this.tagPartner, this.viewModel})
      : super(key: key);
  @override
  _TagPartnerListPageState createState() => _TagPartnerListPageState();
}

class _TagPartnerListPageState extends State<TagPartnerListPage> {
  Color color = Colors.grey;
  List<Tag> tagPartner = [];
  @override
  void initState() {
    super.initState();
    widget.viewModel.tagPartners.clear();
    if (widget.tagPartner != null) {
      widget.viewModel.tagPartners.addAll(widget.tagPartner);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(children: <Widget>[
      ...List.generate(
          widget.viewModel.tagPartners.length ?? 0,
          (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
                child: RawChip(
                  onDeleted: () {
                    setState(() {
                      widget.viewModel.tagPartners.removeAt(index);
                    });
                  },
                  deleteIcon: const Icon(
                    Icons.clear,
                    color: Colors.grey,
                    size: 20,
                  ),
                  label: Text(widget.viewModel.tagPartners[index].name),
                  selected: false,
                ),
              )),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        child: ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: const <Widget>[
              Icon(
                Icons.add,
                color: Colors.grey,
                size: 20,
              ),
              Text("Thêm"),
            ],
          ),
          onSelected: (value) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TagListPage(
                          tags: widget.tags,
                        ))).then((value) {
              if (value != null) {
                setState(() {
                  if (!widget.viewModel.tagPartners
                      .any((e) => value.name == e.name)) {
                    widget.viewModel.tagPartners.add(value);
                  }
                });
              }
            });
          },
          selected: false,
        ),
      )
    ]);

//    return Container(
//      child: ListView.separated(
//        itemCount: widget.tags.length,
//        separatorBuilder: (context, index) => Divider(
//          height: 1,
//        ),
//        itemBuilder: (context, index) {
//          return ListTile(
//            trailing: widget.tags[index].isSelect
//                ? Icon(
//                    Icons.check,
//                    color: Colors.green,
//                  )
//                : SizedBox(),
//            title: InkWell(
//                onTap: () {
//                  setState(() {
//                    widget.tags[index].isSelect = !widget.tags[index].isSelect;
//                  });
//                },
//                child: Text(
//                  widget.tags[index].name,
//                  style: TextStyle(color: color),
//                )),
//          );
//        },
//      ),
//    );
  }
}
