import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vc_geradores/src/connections/budgetDao.dart';
import 'package:vc_geradores/src/views/budget/helperBudget.dart';

import '../../models/budgetModel.dart';

class CreateBudget extends StatefulWidget {
  final String budgetId;
  const CreateBudget(this.budgetId);

  @override
  _CreateBudget createState() => _CreateBudget();
}

List<GlobalKey<FormState>> formKeys = [
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>(),
  GlobalKey<FormState>()
];

class _CreateBudget extends State<CreateBudget> {
  BudgetModel budgetModel = BudgetModel();

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
  final eventoHoraUsoText = TextEditingController();
  final eventoDataInicio = TextEditingController();

  //forma de pagamento
  final formaPagamentoTextValue = TextEditingController();

  bool completed = false;
  int _currentStep = 0;
  List<Step> spr = <Step>[];

  bool selectedRadio = true;

  Widget build(BuildContext context) {
    _getBudget();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Orçamentos'),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            //drawer: SideBar(),
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
                    : Expanded(
                        child: Center(
                            child: AlertDialog(
                        title: Text('Orçamento Salvo'),
                        content: Text('Deseja imprimir agora?'),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () => printPdf(this.budgetModel),
                              child: Text('Imprimir')),
                          FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Finalizar')),
                        ],
                      ))),
              ],
            )));
  }

  Future<void> _getBudget() async {
    BudgetModel oldbudgetModel = BudgetModel();

    if (widget.budgetId != null) {
      oldbudgetModel = await getBudgetById(int.parse(widget.budgetId));

      if (oldbudgetModel != null) {
        nomeClienteText.text = this.budgetModel.clientName != null
            ? this.budgetModel.clientName
            : oldbudgetModel.clientName;
        cidadeClienteText.text = this.budgetModel.clientCity != null
            ? this.budgetModel.clientCity
            : oldbudgetModel.clientCity;
        emailClienteText.text = this.budgetModel.clientEmail != null
            ? this.budgetModel.clientEmail
            : oldbudgetModel.clientEmail;
        telefoneClienteText.text = this.budgetModel.clientPhone != null
            ? this.budgetModel.clientPhone
            : oldbudgetModel.clientPhone;
        geradorKvaText.text = this.budgetModel.generatorKva != null
            ? this.budgetModel.generatorKva
            : oldbudgetModel.generatorKva;
        geradorValueText.text = this.budgetModel.generatorValue != null
            ? this.budgetModel.generatorValue
            : oldbudgetModel.generatorValue;
        geradorOperatorValueText.text =
            this.budgetModel.generatorOperatorValue != null
                ? this.budgetModel.generatorOperatorValue
                : oldbudgetModel.generatorOperatorValue;
        eventoLocalText.text = this.budgetModel.eventLocal != null
            ? this.budgetModel.eventLocal
            : oldbudgetModel.eventLocal;
        eventoHoraAdicionalText.text =
            this.budgetModel.eventAdditionalhour != null
                ? this.budgetModel.eventAdditionalhour
                : oldbudgetModel.eventAdditionalhour;
        eventoHoraUsoText.text = this.budgetModel.eventHoursUsed != null
            ? this.budgetModel.eventHoursUsed
            : oldbudgetModel.eventHoursUsed;
        eventoDataInicio.text = this.budgetModel.eventDateStart != null
            ? this.budgetModel.eventDateStart
            : oldbudgetModel.eventDateStart;
        formaPagamentoTextValue.text = this.budgetModel.paymentType != null
            ? this.budgetModel.paymentType
            : oldbudgetModel.paymentType;
      }
    }
  }

//form steps
  List<Step> _getSteps(BuildContext context) {
    spr = [
      Step(
          title: Text("Evento"),
          isActive: _getStateActive(0),
          state: _getState(0),
          content: Form(
              key: formKeys[0],
              autovalidate: true,
              child: Column(children: <Widget>[
                DateTimeField(
                    format: DateFormat("dd/MM/yyyy"),
                    decoration:
                        const InputDecoration(labelText: "Data do Evento"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          initialDate: currentValue ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                    },
                    controller: eventoDataInicio,
                    onChanged: (text) {
                      this.budgetModel.eventDateStart =
                          DateFormat("dd/MM/yyyy").format(text);
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione uma data';
                      }
                    }),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Local evento"),
                    controller: eventoLocalText,
                    onChanged: (text) {
                      this.budgetModel.eventLocal = text.toString();
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Preencha o local do evento';
                      }
                    }),
              ]))),
      Step(
          title: Text("Cliente"),
          isActive: _getStateActive(1),
          state: _getState(1),
          content: Form(
              key: formKeys[1],
              autovalidate: true,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Nome Cliente"),
                    controller: nomeClienteText,
                    onChanged: (text) {
                      this.budgetModel.clientName = text;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Preencha o nome do cliente';
                      }
                    },
                  ),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Cidade Cliente"),
                      controller: cidadeClienteText,
                      onChanged: (text) {
                        this.budgetModel.clientCity = text;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 1) {
                          return 'Preencha a cidade do cliente';
                        }
                      }),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Telefone Cliente"),
                      keyboardType: TextInputType.phone,
                      controller: telefoneClienteText,
                      onChanged: (text) {
                        this.budgetModel.clientPhone = text;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 1) {
                          return 'Preencha o telefone do cliente';
                        }
                      }),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Email Cliente"),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailClienteText,
                      onChanged: (text) {
                        this.budgetModel.clientEmail = text;
                      },
                      validator: (value) {
                        if (value.isEmpty || value.length < 1) {
                          return 'Preencha o email do cliente';
                        }
                      }),
                ],
              ))),
      Step(
          title: Text("Gerador"),
          isActive: _getStateActive(2),
          state: _getState(2),
          content: Form(
              key: formKeys[2],
              autovalidate: true,
              child: Column(children: <Widget>[
                TextFormField(
                    decoration: const InputDecoration(labelText: "KVA gerador"),
                    keyboardType: TextInputType.number,
                    controller: geradorKvaText,
                    onChanged: (text) {
                      this.budgetModel.generatorKva = text;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Preencha o valor KVA do gerador';
                      }
                    }),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Preço do gerador"),
                    keyboardType: TextInputType.number,
                    controller: geradorValueText,
                    onChanged: (text) {
                      this.budgetModel.generatorValue = text;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Preencha o preço do gerador';
                      }
                    }),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Preço do operador"),
                    keyboardType: TextInputType.number,
                    controller: geradorOperatorValueText,
                    onChanged: (text) {
                      this.budgetModel.generatorOperatorValue = text;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Preencha o preço do operador';
                      }
                    }),
                Row(
                  children: <Widget>[
                    Radio(
                      groupValue: selectedRadio,
                      value: true,
                      onChanged: (value) => _changeRadioModeUse(value),
                    ),
                    Text(" MODO STAND BY"),
                    Radio(
                        groupValue: selectedRadio,
                        value: false,
                        onChanged: (value) => _changeRadioModeUse(value)),
                    Text("MODO USO"),
                  ],
                ),
                Visibility(
                  visible: selectedRadio,
                  child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Valor hora adicional"),
                      keyboardType: TextInputType.number,
                      controller: eventoHoraAdicionalText,
                      onChanged: (text) {
                        this.budgetModel.eventAdditionalhour = text;
                      },
                      validator: (value) {
                        if (selectedRadio == true &&
                            (value.isEmpty || value.length < 1)) {
                          return 'Preencha o valor da hora adicional';
                        }
                      }),
                ),
                Visibility(
                  visible: !selectedRadio,
                  child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Total de horas de uso"),
                      keyboardType: TextInputType.number,
                      controller: eventoHoraUsoText,
                      onChanged: (text) {
                        this.budgetModel.eventHoursUsed = text;
                      },
                      validator: (value) {
                        if (selectedRadio == false &&
                            (value.isEmpty || value.length < 1)) {
                          return 'Preencha o valor de horas de uso';
                        }
                      }),
                )
              ]))),
      Step(
          title: Text("Pagamento"),
          isActive: _getStateActive(3),
          state: _getState(3),
          content: Form(
              key: formKeys[3],
              autovalidate: true,
              child: Column(children: <Widget>[
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Forma de pagamento"),
                    controller: formaPagamentoTextValue,
                    onChanged: (text) {
                      this.budgetModel.paymentType = text;
                    },
                    validator: (value) {
                      if (value.isEmpty || value.length < 1) {
                        return 'Preencha a forma de pagamento';
                      }
                    }),
              ])))
    ];

    return spr;
  }

  void _changeRadioModeUse(dynamic value) {
    setState(() => {
          selectedRadio = value,
          this.budgetModel.generatorIsStandBy = value ? 1 : 0
        });
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
      return const Text("Salvar");
    else
      return const Text("Próximo");
  }

  bool showBackButton() {
    return _currentStep != 0 ? true : false;
  }

  void _moveToNext() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      if (formKeys[_currentStep].currentState.validate()) {
        if (_currentStep + 1 == spr.length) {
          _saveBudget();
          completed = true;
        }
        if (_currentStep + 1 != spr.length) _currentStep++;
      }
    });
  }

  void _moveToLast() {
    setState(() {
      if (_currentStep != 0) _currentStep--;
    });
  }

  void _saveBudget() async {
    try {
      if (eventoDataInicio.text != null) {
        var eventDateSplit = eventoDataInicio.text.split('/');
        this.budgetModel.budgetCode =
            eventDateSplit[2] + eventDateSplit[1] + eventDateSplit[0];
      }
      this.budgetModel.id =
          widget.budgetId != null ? int.parse(widget.budgetId) : null;

      if (this.budgetModel.id != null) {
        this.budgetModel.clientName = nomeClienteText.text != null
            ? nomeClienteText.text
            : this.budgetModel.clientName;
        this.budgetModel.clientCity = cidadeClienteText.text != null
            ? cidadeClienteText.text
            : this.budgetModel.clientCity;

        this.budgetModel.clientEmail = emailClienteText.text != null
            ? emailClienteText.text
            : this.budgetModel.clientEmail;

        this.budgetModel.clientPhone = telefoneClienteText.text != null
            ? telefoneClienteText.text
            : this.budgetModel.clientPhone;

        this.budgetModel.generatorKva = geradorKvaText.text != null
            ? geradorKvaText.text
            : this.budgetModel.generatorKva;

        this.budgetModel.generatorValue = geradorValueText.text != null
            ? geradorValueText.text
            : this.budgetModel.generatorValue;

        this.budgetModel.generatorOperatorValue =
            geradorOperatorValueText.text != null
                ? geradorOperatorValueText.text
                : this.budgetModel.generatorOperatorValue;

        this.budgetModel.eventLocal = eventoLocalText.text != null
            ? eventoLocalText.text
            : this.budgetModel.eventLocal;

        this.budgetModel.eventAdditionalhour =
            eventoHoraAdicionalText.text != null
                ? eventoHoraAdicionalText.text
                : this.budgetModel.eventAdditionalhour;

        this.budgetModel.eventHoursUsed = eventoHoraUsoText.text != null
            ? eventoHoraUsoText.text
            : this.budgetModel.eventHoursUsed;

        this.budgetModel.eventDateStart = eventoDataInicio.text != null
            ? eventoDataInicio.text
            : this.budgetModel.eventDateStart;

        this.budgetModel.paymentType = formaPagamentoTextValue.text != null
            ? formaPagamentoTextValue.text
            : this.budgetModel.paymentType;

        await updateBudget(this.budgetModel);
      } else
        await insertBudget(this.budgetModel);
    } catch (e) {
      throw e;
    }
  }
}
