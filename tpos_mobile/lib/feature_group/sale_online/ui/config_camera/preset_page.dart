import 'package:camera_with_rtmp/camera.dart';
import 'package:flutter/material.dart';

class PresetPage extends StatefulWidget {
  const PresetPage({this.preset});
  final ResolutionPreset preset;

  @override
  _PresetPageState createState() => _PresetPageState();
}

class _PresetPageState extends State<PresetPage> {
  List<Map<String, dynamic>> presets = [
    {
      'key': ResolutionPreset.low,
      'value': '240p',
    },
    {'key': ResolutionPreset.medium, 'value': '480p'},
    {
      'key': ResolutionPreset.high,
      'value': '720p',
    },
    {'key': ResolutionPreset.veryHigh, 'value': '1080p'},
    {'key': ResolutionPreset.ultraHigh, 'value': '2160p'}
  ];

  ResolutionPreset presetSelected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    presetSelected = widget.preset;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.white,
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
          child: Text('Chất lượng',
              style: TextStyle(color: Colors.grey[700], fontSize: 15)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.grey),
            onPressed: () {
              Navigator.pop(context, presetSelected);
            },
          )
        ],
      ),
      body: Column(children: [
        const SizedBox(height: 12),
        Container(
          color: Colors.white,
          child: Column(
            children: [
              ...presets
                  .map((e) => ListTile(
                        onTap: () {
                          setState(() {
                            presetSelected = e['key'];
                          });
                        },
                        title: Text(e['value'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13)),
                        trailing: Visibility(
                          visible: presetSelected == e['key'],
                          child: const Icon(Icons.check,
                              color: Colors.black, size: 15),
                        ),
                      ))
                  .toList(),
            ],
          ),
        )
      ]),
    );
  }
}
