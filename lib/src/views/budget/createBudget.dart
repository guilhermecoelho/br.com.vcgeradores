import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vc_geradores/src/connections/budgetDao.dart';
import 'package:vc_geradores/src/views/budget/helperBudget.dart';

import '../../models/budgetModel.dart';
import '../../sidebar.dart';

class CreateBudget extends StatefulWidget {
  final String? budgetId;
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
  final geradorCableText = TextEditingController();
  final generatorObservationText = TextEditingController();

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
            drawer: SideBar(),
            body: Column(
              children: <Widget>[
                !completed
                    ? Expanded(
                        child: Stepper(
                            type: StepperType.vertical,
                            controlsBuilder: (BuildContext context, ControlsDetails details) {
                              return Row(
                                children: <Widget>[
                                  SizedBox(height: 100),
                                  if (showBackButton())
                                    TextButton(
                                      onPressed: details.onStepCancel,
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: const Text('Voltar'),
                                    ),
                                  Spacer(),
                                  ElevatedButton(
                                    onPressed: details.onStepContinue,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: _buttonText(),
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
                          TextButton(
                              onPressed: () => {CallPreview(context,budgetModel)},
                              child: Text('Imprimir')),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Finalizar')),
                        ],
                      ))),
              ],
            )));
  }

  Future<void> _getBudget() async {
    if (widget.budgetId != null) {
      BudgetModel? oldbudgetModel = await getBudgetById(int.parse(widget.budgetId!));

      if (oldbudgetModel != null) {
        nomeClienteText.text = budgetModel.clientName ?? oldbudgetModel.clientName ?? '';
        cidadeClienteText.text = budgetModel.clientCity ?? oldbudgetModel.clientCity ?? '';
        emailClienteText.text = budgetModel.clientEmail ?? oldbudgetModel.clientEmail ?? '';
        telefoneClienteText.text = budgetModel.clientPhone ?? oldbudgetModel.clientPhone ?? '';
        geradorKvaText.text = budgetModel.generatorKva ?? oldbudgetModel.generatorKva ?? '';
        geradorValueText.text = budgetModel.generatorValue ?? oldbudgetModel.generatorValue ?? '';
        geradorOperatorValueText.text = budgetModel.generatorOperatorValue ?? oldbudgetModel.generatorOperatorValue ?? '';
        geradorOperatorValueText.text = budgetModel.generatorCableValue ?? oldbudgetModel.generatorCableValue ?? '';
        generatorObservationText.text = budgetModel.generatorObservation ?? oldbudgetModel.generatorObservation ?? '';
        eventoLocalText.text = budgetModel.eventLocal ?? oldbudgetModel.eventLocal ?? '';
        eventoHoraAdicionalText.text = budgetModel.eventAdditionalhour ?? oldbudgetModel.eventAdditionalhour ?? '';
        eventoHoraUsoText.text = budgetModel.eventHoursUsed ?? oldbudgetModel.eventHoursUsed ?? '';
        eventoDataInicio.text = budgetModel.eventDateStart ?? oldbudgetModel.eventDateStart ?? '';
        formaPagamentoTextValue.text = budgetModel.paymentType ?? oldbudgetModel.paymentType ?? '';

        selectedRadio = budgetModel.generatorIsStandBy == null
            ? (oldbudgetModel.generatorIsStandBy == 1)
            : selectedRadio;
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
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: <Widget>[
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Data do Evento"),
                    controller: eventoDataInicio,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100));
                      if (pickedDate != null) {
                        String formattedDate = DateFormat("dd/MM/yyyy").format(pickedDate);
                        eventoDataInicio.text = formattedDate;
                        budgetModel.eventDateStart = formattedDate;
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Selecione uma data';
                      }
                      return null;
                    }),
                LocaEvent(),
              ]))),
      Step(
          title: Text("Cliente"),
          isActive: _getStateActive(1),
          state: _getState(1),
          content: Form(
              key: formKeys[1],
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Nome Cliente"),
                    controller: nomeClienteText,
                    onChanged: (text) {
                      budgetModel.clientName = text;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o nome do cliente';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Cidade Cliente"),
                      controller: cidadeClienteText,
                      onChanged: (text) {
                        budgetModel.clientCity = text;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha a cidade do cliente';
                        }
                      }),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Telefone Cliente"),
                      keyboardType: TextInputType.phone,
                      controller: telefoneClienteText,
                      onChanged: (text) {
                        budgetModel.clientPhone = text;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Preencha o telefone do cliente';
                        }
                      }),
                  TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Email Cliente"),
                      keyboardType: TextInputType.emailAddress,
                      controller: emailClienteText,
                      onChanged: (text) {
                        budgetModel.clientEmail = text;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
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
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: <Widget>[
                TextFormField(
                    decoration: const InputDecoration(labelText: "KVA gerador"),
                    keyboardType: TextInputType.number,
                    controller: geradorKvaText,
                    onChanged: (text) {
                      budgetModel.generatorKva = text;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o valor KVA do gerador';
                      }
                    }),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Preço do gerador"),
                    keyboardType: TextInputType.number,
                    controller: geradorValueText,
                    onChanged: (text) {
                      budgetModel.generatorValue = text;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o preço do gerador';
                      }
                    }),
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Preço do operador"),
                    keyboardType: TextInputType.number,
                    controller: geradorOperatorValueText,
                    onChanged: (text) {
                      budgetModel.generatorOperatorValue = text;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o preço do operador';
                      }
                    }),
                TextFormField(
                    decoration: const InputDecoration(labelText: "Conjunto Cabos"),
                    keyboardType: TextInputType.number,
                    controller: geradorCableText,
                    onChanged: (text) {
                      budgetModel.generatorCableValue = text;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha o valor Conjunto Cabos';
                      }
                    }),
                RadioGroup<bool>(
                  groupValue: selectedRadio,
                  onChanged: (value) => _changeRadioModeUse(value),
                  child: Column(
                    children: [
                      RadioListTile<bool>(
                        title: const Text("MODO STAND BY"),
                        value: true,
                      ),
                      RadioListTile<bool>(
                        title: const Text("MODO USO"),
                        value: false,
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: selectedRadio,
                  child: TextFormField(
                      decoration: const InputDecoration(
                          labelText: "Valor hora adicional"),
                      keyboardType: TextInputType.number,
                      controller: eventoHoraAdicionalText,
                      onChanged: (text) {
                        budgetModel.eventAdditionalhour = text;
                      },
                      validator: (value) {
                        if (selectedRadio == true &&
                            (value == null || value.isEmpty)) {
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
                        budgetModel.eventHoursUsed = text;
                      },
                      validator: (value) {
                        if (selectedRadio == false &&
                            (value == null || value.isEmpty)) {
                          return 'Preencha o valor de horas de uso';
                        }
                      }),
                ),
                TextFormField(
                    decoration: const InputDecoration(labelText: "Observações"),
                    controller: generatorObservationText,
                    onChanged: (text) {
                      budgetModel.generatorObservation = text;
                    })
              ]))),
      Step(
          title: Text("Pagamento"),
          isActive: _getStateActive(3),
          state: _getState(3),
          content: Form(
              key: formKeys[3],
              autovalidateMode: AutovalidateMode.always,
              child: Column(children: <Widget>[
                TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Forma de pagamento"),
                    controller: formaPagamentoTextValue,
                    onChanged: (text) {
                      budgetModel.paymentType = text;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Preencha a forma de pagamento';
                      }
                    }),
              ])))
    ];

    return spr;
  }

  TextFormField LocaEvent() {
    return TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Local evento"),
                  controller: eventoLocalText,
                  onChanged: (text) {
                    budgetModel.eventLocal = text.toString();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Preencha o local do evento';
                    }
                  });
  }

  void _changeRadioModeUse(dynamic value) {
    setState(() {
          selectedRadio = value;
          budgetModel.generatorIsStandBy = value ? 1 : 0;
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
      if (formKeys[_currentStep].currentState?.validate() ?? false) {
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
      if (eventoDataInicio.text.isNotEmpty) {
        var eventDateSplit = eventoDataInicio.text.split('/');
        budgetModel.budgetCode =
            eventDateSplit[2] + eventDateSplit[1] + eventDateSplit[0];
      }
      budgetModel.id =
          widget.budgetId != null ? int.parse(widget.budgetId!) : null;

      if (budgetModel.id != null) {
        budgetModel.clientName = nomeClienteText.text.isNotEmpty
            ? nomeClienteText.text
            : budgetModel.clientName;
        budgetModel.clientCity = cidadeClienteText.text.isNotEmpty
            ? cidadeClienteText.text
            : budgetModel.clientCity;

        budgetModel.clientEmail = emailClienteText.text.isNotEmpty
            ? emailClienteText.text
            : budgetModel.clientEmail;

        budgetModel.clientPhone = telefoneClienteText.text.isNotEmpty
            ? telefoneClienteText.text
            : budgetModel.clientPhone;

        budgetModel.generatorKva = geradorKvaText.text.isNotEmpty
            ? geradorKvaText.text
            : budgetModel.generatorKva;

        budgetModel.generatorValue = geradorValueText.text.isNotEmpty
            ? geradorValueText.text
            : budgetModel.generatorValue;

        budgetModel.generatorOperatorValue =
            geradorOperatorValueText.text.isNotEmpty
                ? geradorOperatorValueText.text
                : budgetModel.generatorOperatorValue;

        budgetModel.generatorCableValue =
            geradorOperatorValueText.text.isNotEmpty
                ? geradorOperatorValueText.text
                : budgetModel.generatorCableValue;

        budgetModel.generatorObservation =
            generatorObservationText.text.isNotEmpty
                ? generatorObservationText.text
                : budgetModel.generatorObservation;

        budgetModel.eventLocal = eventoLocalText.text.isNotEmpty
            ? eventoLocalText.text
            : budgetModel.eventLocal;

        budgetModel.eventAdditionalhour =
            eventoHoraAdicionalText.text.isNotEmpty
                ? eventoHoraAdicionalText.text
                : budgetModel.eventAdditionalhour;

        budgetModel.eventHoursUsed = eventoHoraUsoText.text.isNotEmpty
            ? eventoHoraUsoText.text
            : budgetModel.eventHoursUsed;

        budgetModel.eventDateStart = eventoDataInicio.text.isNotEmpty
            ? eventoDataInicio.text
            : budgetModel.eventDateStart;

        budgetModel.paymentType = formaPagamentoTextValue.text.isNotEmpty
            ? formaPagamentoTextValue.text
            : budgetModel.paymentType;

        budgetModel.generatorIsStandBy = selectedRadio ? 1 : 0;

        await updateBudget(budgetModel);
      } else {
        budgetModel.generatorIsStandBy = selectedRadio ? 1 : 0;
        await insertBudget(budgetModel);
      }
    } catch (e) {
      rethrow;
    }
    finally{
     
    }
  }
}
