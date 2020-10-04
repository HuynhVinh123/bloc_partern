import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tpos_mobile/app_core/viewmodel/viewmodel_base.dart';

class UIViewModelBase<T extends ViewModel> extends StatelessWidget {
  final T viewModel;
  final Widget child;
  final Widget Function(BuildContext) errorBuilder;
  final Widget Function(BuildContext) indicatorBuilder;
  final Color defaultIndicatorColor;
  final Color defaultIndicatorBackgroundColor;
  final Color backgroundColor;
  final bool closeKeyboardOnTap;
  UIViewModelBase(
      {@required this.viewModel,
      @required this.child,
      this.errorBuilder,
      this.indicatorBuilder,
      this.defaultIndicatorColor,
      this.defaultIndicatorBackgroundColor,
      this.backgroundColor,
      this.closeKeyboardOnTap = false});

  Widget _buildDefaultIndicator({String message, BuildContext context}) {
    return Material(
      color: backgroundColor ?? Theme.of(context).primaryColor.withOpacity(0.2),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  spreadRadius: 0,
                  blurRadius: 0,
                  color: Colors.grey,
                )
              ],
              color: defaultIndicatorBackgroundColor ?? Colors.white,
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: SpinKitCircle(
                    color: Theme.of(context).primaryColor,
                    size: 50,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: Text(message ?? "")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: defaultIndicatorBackgroundColor ?? Colors.grey.shade300,
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("Có gì đó không đúng rồi"),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    child: const Text("Về trang trước"),
                    onPressed: () {},
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  RaisedButton(
                    child: const Text("Thử lại"),
                    onPressed: () {},
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<T>(
      model: viewModel,
      child: GestureDetector(
        onTap: () {
          if (closeKeyboardOnTap) {
            FocusScope.of(context)?.requestFocus(FocusNode());
          }
        },
        child: Stack(
          children: <Widget>[
            child,
            StreamBuilder<ViewModelState>(
              stream: viewModel.stateController,
              initialData: ViewModelState(isBusy: true, message: "Đang tải..."),
              builder: (context, snapshot) {
                if (snapshot.data.isError) {
                  return errorBuilder ?? _buildDefaultError();
                }

                if (snapshot.data.isBusy) {
                  return indicatorBuilder ??
                      _buildDefaultIndicator(
                          message: snapshot.data.message, context: context);
                }
                return SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UIViewModelBaseTest extends StatefulWidget {
  @override
  _UIViewModelBaseTestState createState() => _UIViewModelBaseTestState();
}

class _UIViewModelBaseTestState extends State<UIViewModelBaseTest> {
  var vm = UIViewModelTestViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test UID"),
        actions: <Widget>[
          RaisedButton(
            child: Text("Loadding.."),
            onPressed: () {
              vm.initCommand(false);
            },
          ),
          RaisedButton(
            child: Text("LoaddingError.."),
            onPressed: () {
              vm.initCommand(true);
            },
          )
        ],
      ),
      body: UIViewModelBase(
        viewModel: vm,
        child: Container(
          child: ListView(
            children: <Widget>[
              for (int i = 0; i < 10; i++)
                ListTile(
                  title: Text(i.toString()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class UIViewModelTestViewModel extends ViewModel {
  UIViewModelTestViewModel() {
    onStateAdd(false);
  }
  Future<void> initCommand(bool isError) async {
    onStateAdd(true, message: "Đang  tải dữ liệu");

    await Future.delayed(new Duration(seconds: 60));
    if (isError) {
      onStateAdd(null, state: ViewModelState.error("Có lỗi gì rồi"));
      return;
    }
    onStateAdd(false);
  }
}
