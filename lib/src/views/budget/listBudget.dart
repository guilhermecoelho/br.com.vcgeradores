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
      home: ListBudgetBody(),
    );
  }
}

class _ListBudgetBody extends State<ListBudgetBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamentos'),
      ),
      //drawer: SideBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => CreateBudget(null))),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder<List<BudgetModel>>(
          future: listBudget(),
          initialData: [],
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? ListView.separated(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final budget = snapshot.data![index];
                      return Card(
                        child: ListTile(
                          title: Text('${budget.clientName ?? ''} ${budget.eventDateStart ?? ''}'),
                          trailing: Row(children: <Widget>[
                            PopupMenuButton(
                                onSelected: (result) async {
                                  switch (result.index) {
                                    case 0:
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateBudget(budget.id?.toString())));
                                      break;
                                    case 1:
                                      BudgetModel? budgetMode =
                                          await getBudgetById(budget.id!);
                                      if (budgetMode != null) {
                                        printPdf(budgetMode);
                                      }
                                      break;
                                    case 2:
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                  "Deseja realmente excluir?"),
                                              actions: <Widget>[
                                                TextButton(
                                                    onPressed: () =>
                                                        _deleteConfirm(
                                                            context,
                                                            budget.id!),
                                                    child: Text('Sim')),
                                                TextButton(
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
                                      budget.id?.toString()))),
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
      BudgetModel budget = BudgetModel(id: id);
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
          content: Text(selectedItem.clientName ?? ''),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK')),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('CANCEL')),
          ],
        );
      });
}
