import 'package:flutter/material.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base_provider.dart';

class ReloadListPage extends StatelessWidget {
  const ReloadListPage({this.onPressed, this.child, this.vm});
  final VoidCallback onPressed;
  final Widget child;
  final ViewModelBase vm;

  @override
  Widget build(BuildContext context) {
    print(vm.viewModelState.isError.toString());
    if (vm.viewModelState.isBusy) {
      return const SizedBox();
    }
    if (vm.viewModelState.isError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 70,
                width: 70,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Transform.scale(
                    scale: 1.65,
//                    child: FlareActor(
//                      "images/empty_state.flr",
//                      alignment: Alignment.center,
//                      fit: BoxFit.fitWidth,
//                      animation: "idle",
//                    ),
                    child: const Icon(Icons.flag),
                  ),
                ),
              ),
              const Text(
                "Không tải được dữ liệu. Vui lòng thử lại",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.refresh),
                    Text("Tải lại"),
                  ],
                ),
                onPressed: () {
                  onPressed();
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return child;
    }
  }
}
