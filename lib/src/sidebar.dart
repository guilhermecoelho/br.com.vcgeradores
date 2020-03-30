import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          child: Text('Menu'),
          decoration: BoxDecoration(color: Colors.blue),
        ),
        ListTile(
          title: Text('Item 1'),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ]),
    );
  }
}
