import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vc_geradores/src/connections/budgetDao.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';
import 'package:vc_geradores/src/views/budget/createBudget.dart';

import '../../sidebar.dart';

class ListBudget extends StatefulWidget {
  @override
  _ListBudget createState() => _ListBudget();
}

enum PopUpItems { edit, print, sendEmail }

}
class _ListBudget extends State<ListBudget> {
  Future getProjectDetails() async {
    List<BudgetModel> projetcList = await listBudget();
    return projetcList;
  }

  void _popupDialog(
      BuildContext context, dynamic selectedItem, dynamic selectedButton) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(selectedButton.index.toString()),
            content: Text(selectedItem.clientName),
            actions: <Widget>[
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK')),
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('CANCEL')),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Listar '),
        ),
        drawer: SideBar(),
        floatingActionButton: new FloatingActionButton(
          onPressed: () => Navigator.push(context,
              new MaterialPageRoute(builder: (context) => CreateBudget())),
          child: Icon(Icons.navigation),
        ),
        body: FutureBuilder<List>(
            future: listBudget(),
            initialData: List(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? new ListView.separated(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data[index].clientName),
                            trailing: Row(children: <Widget>[
                              PopupMenuButton(
                                  onSelected: (result) {
                                    if (result.index == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateBudget()));
                                    } else
                                      _popupDialog(context,
                                          snapshot.data[index], result);
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<PopUpItems>>[
                                        const PopupMenuItem<PopUpItems>(
                                            value: PopUpItems.edit,
                                            child: ListTile(
                                              title: Text('Editar'),
                                              trailing: Icon(Icons.edit),
                                            )),
                                        const PopupMenuItem<PopUpItems>(
                                          value: PopUpItems.print,
                                          child: ListTile(
                                            title: Text('Imprimir'),
                                            trailing: Icon(Icons.print),
                                          ),
                                        ),
                                        const PopupMenuItem<PopUpItems>(
                                          value: PopUpItems.sendEmail,
                                          child: ListTile(
                                            title: Text('Enviar'),
                                            trailing: Icon(Icons.email),
                                          ),
                                        ),
                                      ]),
                            ], mainAxisSize: MainAxisSize.min),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    )
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
