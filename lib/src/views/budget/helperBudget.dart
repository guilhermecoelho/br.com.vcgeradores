import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';

void printPdf(BudgetModel budgetModel) {
  Printing.layoutPdf(
    onLayout: (PdfPageFormat format) async => await Printing.convertHtml(
      format: format,
      html: await _buildHTML(budgetModel),
    ),
  );
}

Future<String> _buildHTML(BudgetModel budgetModel) async {
  try {
    String file = budgetModel.generatorIsStandBy == 1
        ? await rootBundle.loadString('assets/html/budgetStandBy.html')
        : await rootBundle.loadString('assets/html/budgetModeUse.html');

    file = file.replaceFirst('orcamentoText', budgetModel.budgetCode);
    file = file.replaceFirst('nomeClienteText', budgetModel.clientName);
    file = file.replaceFirst('cidadeClienteText', budgetModel.clientCity);
    file = file.replaceFirst('telefoneClienteText', budgetModel.clientPhone);
    file = file.replaceFirst('emailClienteText', budgetModel.clientEmail);

    // descrição gerador
    //geradorModoUsoText
    file = file.replaceFirst('geradorModoUsoText',
        budgetModel.generatorIsStandBy == 1 ? "MODO STANDY BY" : "MODO USO");
    file = file.replaceFirst('geradorKvaText', budgetModel.generatorKva);
    file = file.replaceFirst('geradorValueText', budgetModel.generatorValue);
    file = file.replaceFirst(
        'geradorOperatorValueText', budgetModel.generatorOperatorValue);
    file = file.replaceFirst(
        'geradorTotalValue',
        _totalValue(
                budgetModel.generatorOperatorValue, budgetModel.generatorValue)
            .toString());
    //generatorObservation

    file = file.replaceFirst(
        'generatorObservationText',
        budgetModel.generatorObservation != null
            ? budgetModel.generatorObservation
            : ' ');
    //dados evento
    file = file.replaceFirst('eventoLocalText', budgetModel.eventLocal);
    if (budgetModel.generatorIsStandBy == 1)
      file = file.replaceFirst(
          'eventoHoraAdicionalText', budgetModel.eventAdditionalhour);
    file = file.replaceFirst('eventoDataInicio', budgetModel.eventDateStart);

    if (budgetModel.generatorIsStandBy == 0)
      file = file.replaceFirst('eventoHoraUsoText', budgetModel.eventHoursUsed);

    //forma pagamento
    file =
        file.replaceFirst('formaPagamentoTextValue', budgetModel.paymentType);

    // validade orçamento
    file = file.replaceFirst(
        'dataLimiteOrcamento',
        new DateFormat.yMMMMd("pt_BR")
            .format(DateTime.now().add(new Duration(days: 30)))
            .toUpperCase());

    file = file.replaceFirst(
        'dataOrcamento', new DateFormat.yMMMMd("pt_BR").format(DateTime.now()));
    return file;
  } catch (e) {
    // If encountering an error, return 0.
    return 'error';
  }
}

double _totalValue(String firstValue, String secondValue) {
  var first = double.tryParse(firstValue) == null
      ? double.minPositive
      : double.tryParse(firstValue);
  var second = double.tryParse(secondValue) == null
      ? double.minPositive
      : double.tryParse(secondValue);

  return (first + second);
}
