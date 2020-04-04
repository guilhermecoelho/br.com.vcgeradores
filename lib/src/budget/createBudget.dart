import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';
import 'package:vc_geradores/src/sidebar.dart';

import '../models/budgetModel.dart';

class CreateBudget extends StatefulWidget {
  @override
  _CreateBudget createState() => _CreateBudget();
}

class _CreateBudget extends State<CreateBudget> {

  final orcamentoText = TextEditingController();
  final nomeClienteText = TextEditingController();
  final cidadeClienteText = TextEditingController();
  final telefoneClienteText = TextEditingController();
  final emailClienteText = TextEditingController();

  //descrição gerador
  final geradorKvaText = TextEditingController();
  final geradorValueText = TextEditingController();
  final geradorOperatorValueText = TextEditingController();

  //dados evento
  final eventoLocalText = TextEditingController();
  final eventoHoraAdicionalText = TextEditingController();
  final eventoDataInicio = TextEditingController();

  //forma de pagamento
  final formaPagamentoTextValue = TextEditingController();

  static BudgetModel data = new BudgetModel();

  bool completed = false;
  int _currentStep = 0;
  List<Step> spr = <Step>[];

  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Orçamentos'),
            ),
            drawer: SideBar(),
            body: Column(
              children: <Widget>[
                !completed
                    ? Expanded(
                        child: Stepper(
                            type: StepperType.vertical,
                            controlsBuilder: (BuildContext context,
                                {VoidCallback onStepContinue,
                                VoidCallback onStepCancel}) {
                              return Row(
                                children: <Widget>[
                                  SizedBox(height: 100),
                                  if (showBackButton())
                                    FlatButton(
                                      onPressed: onStepCancel,
                                      child: const Text('Voltar'),
                                      color: Colors.red,
                                      textColor: Colors.white,
                                    ),
                                  Spacer(),
                                  FlatButton(
                                    onPressed: onStepContinue,
                                    child: _buttonText(),
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
                      )
                    : Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async =>
                            await Printing.convertHtml(
                          format: format,
                          html: await buildHTML(),
                        ),
                      )
              ],
            )));
  }

  List<Step> _getSteps(BuildContext context) {
    spr = [
      Step(
          title: Text("Evento"),
          isActive: _getStateActive(0),
          state: _getState(0),
          content: Form(
              child: Column(children: <Widget>[
            DateTimeField(
              format: DateFormat("dd/MM/yyyy"),
              decoration: const InputDecoration(labelText: "Data do Evento"),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
              },
              
              controller: eventoDataInicio,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Local evento"),
              controller: eventoLocalText,
            ),
          ]))),
      Step(
          title: Text("Cliente"),
          isActive: _getStateActive(1),
          state: _getState(1),
          content: Form(
              child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: "Nome Cliente"),
                controller: nomeClienteText,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Cidade Cliente"),
                controller: cidadeClienteText,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Telefone Cliente"),
                keyboardType: TextInputType.phone,
                controller: telefoneClienteText,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email Cliente"),
                keyboardType: TextInputType.emailAddress,
                controller: emailClienteText,
              ),
            ],
          ))),
      Step(
          title: Text("Gerador"),
          isActive: _getStateActive(2),
          state: _getState(2),
          content: Form(
              child: Column(children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: "KVA gerador"),
              keyboardType: TextInputType.number,
              controller: geradorKvaText,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Preço do gerador"),
              keyboardType: TextInputType.number,
              controller: geradorValueText,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Preço do operador"),
              keyboardType: TextInputType.number,
              controller: geradorOperatorValueText,
            ),
            TextFormField(
              decoration:
                  const InputDecoration(labelText: "Valor hora adicional"),
              keyboardType: TextInputType.number,
              controller: eventoHoraAdicionalText,
            ),
          ]))),
      Step(
          title: Text("Pagamento"),
          isActive: _getStateActive(3),
          state: _getState(3),
          content: Form(
              child: Column(children: <Widget>[
            TextFormField(
              decoration:
                  const InputDecoration(labelText: "Forma de pagamento"),
              controller: formaPagamentoTextValue,
            ),
          ])))
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

  bool showBackButton() {
    return _currentStep != 0 ? true : false;
  }

  void _moveToNext() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (_currentStep + 1 == spr.length) completed = true;
      if (_currentStep + 1 != spr.length) _currentStep++;
    });
  }

  void _moveToLast() {
    setState(() {
      if (_currentStep != 0) _currentStep--;
    });
  }

  double totalValue(String firstValue, String secondValue) {
    var first = double.tryParse(firstValue) == null
        ? double.minPositive
        : double.tryParse(firstValue);
    var second = double.tryParse(secondValue) == null
        ? double.minPositive
        : double.tryParse(secondValue);

    return (first + second);
  }

  Future<String> buildHTML() async {
    try {
      var file = await rootBundle.loadString('assets/html/budget.html');

      //dados cliente.
      String codeBudget = '';
      if(eventoDataInicio.text != null){
        var eventDateSplit = eventoDataInicio.text.split('/');
        codeBudget = eventDateSplit[2] + eventDateSplit[1] + eventDateSplit[0];
      }

      file = file.replaceFirst('orcamentoText', codeBudget);
      file = file.replaceFirst('nomeClienteText', nomeClienteText.text);
      file = file.replaceFirst('cidadeClienteText', cidadeClienteText.text);
      file = file.replaceFirst('telefoneClienteText', telefoneClienteText.text);
      file = file.replaceFirst('emailClienteText', emailClienteText.text);

      // descrição gerador
      file = file.replaceFirst('geradorKvaText', geradorKvaText.text);
      file = file.replaceFirst('geradorValueText', geradorValueText.text);
      file = file.replaceFirst(
          'geradorOperatorValueText', geradorOperatorValueText.text);
      file = file.replaceFirst(
          'geradorTotalValue',
          totalValue(geradorOperatorValueText.text, geradorValueText.text)
              .toString());

      //dados evento
      file = file.replaceFirst('eventoLocalText', eventoLocalText.text);
      file = file.replaceFirst(
          'eventoHoraAdicionalText', eventoHoraAdicionalText.text);
      file = file.replaceFirst('eventoDataInicio', eventoDataInicio.text);

      //forma pagamento
      file = file.replaceFirst(
          'formaPagamentoTextValue', formaPagamentoTextValue.text);

      // validade orçamento
        file = file.replaceFirst(
          'dataLimiteOrcamento', new DateFormat.yMMMMd("pt_BR").format(DateTime.now().add(new Duration(days: 15))).toUpperCase());

      file = file.replaceFirst(
          'dataOrcamento', new DateFormat.yMMMMd("pt_BR").format(DateTime.now()));
      return file;
    } catch (e) {
      // If encountering an error, return 0.
      return 'error';
    }
  }
}
