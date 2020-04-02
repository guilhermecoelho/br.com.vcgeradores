import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../sidebar.dart';

class TestStep extends StatefulWidget {
  @override
  _TestStep createState() => _TestStep();
}

class MyData {
  String name = '';
  String phone = '';
  String email = '';
  String age = '';
}

class _TestStep extends State<TestStep> {
  final nomeClienteText = TextEditingController();
  final nomeClienteText2 = TextEditingController();

  static MyData data = new MyData();

  int _currentStep = 0;
  List<Step> spr = <Step>[];

  void _moveToNext() {
    setState(() {
      if ((_currentStep + 1) != spr.length) _currentStep++;
    });
  }

  void _moveToLast() {
    setState(() {
      if (_currentStep != 0) _currentStep--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Orçamentos'),
            ),
            drawer: SideBar(),
            body: Center(
              child: Stepper(
                  type: StepperType.horizontal,
                  controlsBuilder: (BuildContext context,
                      {VoidCallback onStepContinue,
                      VoidCallback onStepCancel}) {
                    return Row(
                      children: <Widget>[
                        SizedBox(height: 100),
                        if (showBackButton()) FlatButton(
                          onPressed: onStepCancel,
                          child: const Text('Voltar'),
                          color: Colors.red,
                          textColor: Colors.white,
                        ),
                        Spacer(),
                        FlatButton(
                          onPressed: onStepContinue,
                          child:  _buttonText(),
                          color: Colors.blue,
                          textColor: Colors.white,
                        ),
                      ],
                    );
                  },
                  currentStep: _currentStep,
                  onStepContinue: _moveToNext,
                  onStepCancel: _moveToLast,
                  steps: _getSteps(context)),
            )));
  }

  List<Step> _getSteps(BuildContext context) {
    spr = [
      Step(
          title: Text("Start"),
          isActive: _getStateActive(0),
          state: _getState(0),
          content: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente"),
              onSaved: (String value) {
                data.name = value;
              },
            )
          ])),
      Step(
          title: Text("Second"),
          isActive: _getStateActive(1),
          state: _getState(1),
          content: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 2"),
              //controller: nomeClienteText2,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 2"),
              //controller: nomeClienteText2,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 2"),
              //controller: nomeClienteText2,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 2"),
              //controller: nomeClienteText2,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 2"),
              //controller: nomeClienteText2,
            ),
          ])),
      Step(
          title: Text("Third"),
          isActive: _getStateActive(2),
          state: _getState(2),
          content: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 3"),
              //controller: nomeClienteText2,
            )
          ])),
      Step(
          title: Text("Fourth"),
          isActive: _getStateActive(3),
          state: _getState(3),
          content: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: "Nome Cliente 3"),
              //controller: nomeClienteText2,
            )
          ]))
    ];

    return spr;
  }

  StepState _getState(int i) {
    if (_currentStep == i)
      return StepState.editing;
    else if (_currentStep > i && _currentStep != i)
      return StepState.complete;
    else
      return StepState.indexed;
  }

  bool _getStateActive(int i) {
    if (_currentStep >= i)
      return true;
    else
      return false;
  }

  Text _buttonText() {
    if (_currentStep == spr.length - 1)
      return const Text("Imprimir");
    else
      return const Text("Próximo");
  }

  bool showBackButton(){
     return _currentStep != 0 ? true : false;
  }
}
