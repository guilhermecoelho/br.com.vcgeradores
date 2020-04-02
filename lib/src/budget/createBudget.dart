import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/sidebar.dart';

class CreateBudget extends StatelessWidget {
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

  double totalValue(String firstValue, String secondValue) {
    var first = double.tryParse(firstValue) == null
        ? double.minPositive
        : double.tryParse(firstValue);
    var second = double.tryParse(secondValue) == null
        ? double.minPositive
        : double.tryParse(secondValue);

    return (first + second);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Orçamentos'),
            ),
            drawer: SideBar(),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.print),
              tooltip: 'Imprimir',
              onPressed: () {
                Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async =>
                      await Printing.convertHtml(
                    format: format,
                    html: await buildHTML(),
                  ),
                );
              },
            ),
            body: Center(
              child: SingleChildScrollView(
                  child: Form(
                      child: Column(
                children: <Widget>[
                  //dados cliente
                  DateTimeField(
                    format: DateFormat("dd/MM/yyyy"),
                    decoration:
                        const InputDecoration(labelText: "Data do Evento"),
                    //controller: eventoDataInicio,
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
                    decoration:
                        const InputDecoration(labelText: "Código Orçamento"),
                    keyboardType: TextInputType.datetime,
                    controller: orcamentoText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Nome Cliente"),
                    controller: nomeClienteText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Cidade Cliente"),
                    controller: cidadeClienteText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Telefone Cliente"),
                    keyboardType: TextInputType.phone,
                    controller: telefoneClienteText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Email Cliente"),
                    keyboardType: TextInputType.emailAddress,
                    controller: emailClienteText,
                  ),

                  //descrição gerador
                  TextFormField(
                    decoration: const InputDecoration(labelText: "KVA gerador"),
                    keyboardType: TextInputType.number,
                    controller: geradorKvaText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Preço do gerador"),
                    keyboardType: TextInputType.number,
                    controller: geradorValueText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Preço do operador"),
                    keyboardType: TextInputType.number,
                    controller: geradorOperatorValueText,
                  ),

                  //dados evento
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Local evento"),
                    controller: eventoLocalText,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Valor hora adicional"),
                    keyboardType: TextInputType.number,
                    controller: eventoHoraAdicionalText,
                  ),
                  //forma pagamento
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Forma de pagamento"),
                    controller: formaPagamentoTextValue,
                  ),
                ],
              ))),
            )));
  }

  Future<String> buildHTML() async {
    try {
      var file = await rootBundle.loadString('assets/html/budget.html');

      //dados cliente.
      file = file.replaceFirst('orcamentoText', orcamentoText.text);
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
      file = file.replaceFirst('eventoHoraAdicionalText', eventoHoraAdicionalText.text);
      file = file.replaceFirst('eventoDataInicio', eventoDataInicio.text);

      //forma pagamento
      file = file.replaceFirst('formaPagamentoTextValue', formaPagamentoTextValue.text);
      
      // return contents;
      return file;
    } catch (e) {
      // If encountering an error, return 0.
      return 'error';
    }
  }
}
