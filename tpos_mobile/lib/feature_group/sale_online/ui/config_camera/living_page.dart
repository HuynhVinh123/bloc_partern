import 'package:flutter/material.dart';
import 'package:tpos_api_client/tpos_api_client.dart';

class LivingPage extends StatelessWidget {

  const LivingPage({this.crmTeam});
  final CRMTeam crmTeam;
  
  @override
  Widget build(BuildContext context) {
    return  ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: Colors.grey.shade300,
        child:Text(crmTeam.name.substring(0, 1))
        , backgroundImage: NetworkImage(crmTeam.facebookTypeId == "User"
            ? (crmTeam.facebookUserAvatar ?? "")
            : (crmTeam.facebookPageLogo ?? "")),
      ),
      title: Text(crmTeam.name ?? ''),
    );
  }
}
