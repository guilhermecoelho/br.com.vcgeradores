import 'package:flutter/material.dart';
import 'package:vc_geradores/src/views/budget/listBudget.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Text('VC Geradores',
              style: TextStyle(color: Colors.white, fontSize: 24)),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Orçamentos'),
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => ListBudget()),
              (route) => false,
            );
          },
        ),
      ]),
    );
  }
}
