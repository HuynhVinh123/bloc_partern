// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:tpos_mobile/app.dart';
// import 'package:tpos_mobile/locator.dart';
// import 'package:tpos_mobile/feature_group/settings/setting_page.dart';
// import 'package:tpos_mobile/services/authentication_service.dart';
//
// import 'package:tpos_mobile/src/static_data/application_menu.dart';
// import 'package:tpos_mobile/application/viewmodel/application_viewmodel.dart';
//
// import 'login/login_page.dart';
//
// class MainMenuDrawer extends StatelessWidget {
//   final _applicationVM = locator<ApplicationViewModel>();
//   @override
//   Widget build(BuildContext context) {
//     // Build listMenu
//     var groupIds =
//         applicationMenus.map((f) => f.groupId).toList().toSet().toList();
//
//     List<Widget> menuUi = groupIds.map((f) {
//       var group = applicationMenuGroups.firstWhere((gr) => f == gr.id,
//           orElse: () => null);
//       var groupChild = applicationMenus.where((menu) => menu.groupId == f);
//       return ExpansionTile(
//         leading: group.icon,
//         title: Text("${group.name}"),
//         children: <Widget>[
//           ...groupChild?.map((child) => ListTile(
//                 title: Text("${child.label}"),
//                 onTap: () {
//                   Navigator.pushNamed(context, child.routeName);
//                 },
//               )),
//         ],
//       );
//     }).toList();
//
//     return ScopedModelDescendant<ApplicationViewModel>(
//       builder: (ctx, child, vm) {
//         return new Drawer(
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: ListView(
//                   padding: EdgeInsets.only(top: 0),
//                   children: <Widget>[
// //                    UserAccountsDrawerHeader(
// //                      accountName:
// //                          Text("${_applicationVM.loginUser?.name ?? ""}"),
// //                      accountEmail: Text(
// //                          "${_applicationVM.loginUser?.companyName ?? ""}"),
// //                      currentAccountPicture: CircleAvatar(
// //                        backgroundImage: NetworkImage("images/no_image.png"),
// //                      ),
// //                      onDetailsPressed: () {},
// //                    ),
//
//                     AppBar(
//                       title: Text("TPOS.VN"),
//                       leading: Icon(Icons.home),
//                     ),
//                     ...menuUi,
//                     ListTile(
//                       leading: Icon(
//                         Icons.settings,
//                         color: Theme.of(context).iconTheme.color,
//                       ),
//                       title: Text("Cài đặt"),
//                       onTap: () {
//                         Navigator.pushNamed(context, SettingPage.routeName);
//                       },
//                     ),
//                     ListTile(
//                       leading: Icon(
//                         Icons.exit_to_app,
//                         color: Theme.of(context).iconTheme.color,
//                       ),
//                       title: Text("Đăng xuất"),
//                       onTap: () async {
//                         // Đăng xuất
//                         await locator<IAuthenticationService>().logout();
//                         Navigator.of(context).pushReplacement(
//                             new MaterialPageRoute(builder: (context) {
//                           return new LoginPage();
//                         }));
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.only(bottom: 10, left: 16),
//                 width: double.infinity,
//                 child: Text(
//                   "Phiên bản ${App.appVersion}",
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
