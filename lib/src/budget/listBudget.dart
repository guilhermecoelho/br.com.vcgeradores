import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vc_geradores/src/connections/budgetDao.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';

import '../sidebar.dart';

class ListBudget extends StatefulWidget {
  @override
  _ListBudget createState() => _ListBudget();
}

class _ListBudget extends State<ListBudget> {

  Future getProjectDetails() async {
    List<BudgetModel> projetcList = await listBudget();
    return projetcList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Listar '),
        ),
        drawer: SideBar(),
        body: FutureBuilder<List>(
            future: listBudget(),
            initialData: List(),
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? new ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Text(snapshot.data[index].clientName);
                      })
                  : Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}
