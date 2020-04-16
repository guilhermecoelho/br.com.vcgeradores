import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vc_geradores/src/connections/budgetDao.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';
import 'package:vc_geradores/src/views/budget/createBudget.dart';

import 'helperBudget.dart';

enum PopUpItems { edit, print, delete, sendEmail }

class ListBudget extends StatefulWidget {
  @override
  _ListBudget createState() => _ListBudget();
}

class ListBudgetBody extends StatefulWidget {
  @override
  _ListBudgetBody createState() => _ListBudgetBody();
}

class _ListBudget extends State<ListBudget> {
  Future getProjectDetails() async {
    List<BudgetModel> projetcList = await listBudget();
    return projetcList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new ListBudgetBody(),
    );
  }
}

class _ListBudgetBody extends State<ListBudgetBody> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Orçamentos'),
      ),
      //drawer: SideBar(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () => Navigator.push(context,
            new MaterialPageRoute(builder: (context) => CreateBudget(null))),
        child: Icon(Icons.add),
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
                          title: Text(snapshot.data[index].clientName +
                              ' ' +
                              snapshot.data[index].eventDateStart),
                          trailing: Row(children: <Widget>[
                            PopupMenuButton(
                                onSelected: (result) async {
                                  switch (result.index) {
                                    case 0:
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateBudget(snapshot
                                                      .data[index].id
                                                      .toString())));
                                      break;
                                    case 1:
                                      BudgetModel budgetMode =
                                          await getBudgetById(
                                              snapshot.data[index].id);
                                      printPdf(budgetMode);
                                      break;
                                    case 2:
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Deseja realmente exlcuir?"),
                                              actions: <Widget>[
                                                FlatButton(
                                                    onPressed: () =>
                                                        _deleteConfirm(
                                                            context,
                                                            snapshot.data[index]
                                                                .id),
                                                    child: Text('Sim')),
                                                FlatButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text('Não')),
                                              ],
                                            );
                                          });
                                      break;
                                    default:
                                  }
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
                                        value: PopUpItems.delete,
                                        child: ListTile(
                                          title: Text('Excluir'),
                                          trailing: Icon(Icons.delete),
                                        ),
                                      )
                                      // const PopupMenuItem<PopUpItems>(
                                      //   value: PopUpItems.sendEmail,
                                      //   child: ListTile(
                                      //     title: Text('Enviar'),
                                      //     trailing: Icon(Icons.email),
                                      //   ),
                                      // ),
                                    ]),
                          ], mainAxisSize: MainAxisSize.min),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateBudget(
                                      snapshot.data[index].id.toString()))),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  )
                : Center(child: CircularProgressIndicator());
          }),
    );
  }

  void _deleteConfirm(BuildContext context, int id) {
    setState(() {
      BudgetModel budget = new BudgetModel(id: id);
      deleteBudget(budget);
      Navigator.of(context).pop();
    });
  }
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
