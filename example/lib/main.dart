import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'example_route.dart';
import 'example_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'extended_sliver demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:  Colors.green,
      ),
      initialRoute: Routes.fluttercandiesMainpage,

       onGenerateRoute: (RouteSettings settings) {
        return onGenerateRoute(
          settings: settings,
          getRouteSettings: getRouteSettings,
          routeSettingsWrapper: (FFRouteSettings settings) {
        if (settings.name == Routes.fluttercandiesMainpage ||
              settings.name == Routes.fluttercandiesDemogrouppage ||
              settings.name == Routes.fluttercandiesHomePage ||
              settings.name == Routes.fluttercandiesSliverAppbar) {
            return settings;
          }
            return settings.copyWith(
                widget: CommonWidget(
              child: settings.widget,
              title: settings.routeName,
            ));
          },
        );
      },

    );
  }
}

class CommonWidget extends StatelessWidget {
  const CommonWidget({
    this.child,
    this.title,
  });
  final Widget? child;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title!,
        ),
      ),
      body: child,
    );
  }
}
