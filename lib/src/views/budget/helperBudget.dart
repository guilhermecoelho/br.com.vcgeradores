import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';

Future<void> printPdf(BudgetModel budgetModel) async {
  final String htmlContent = await _buildHTML(budgetModel);

  await Printing.layoutPdf(
    onLayout: (format) => Printing.convertHtml(
      html: htmlContent,
      format: format,
    ),
  );
}

Future<String> _buildHTML(BudgetModel budgetModel) async {
  try {
    String file = budgetModel.generatorIsStandBy == 1
        ? await rootBundle.loadString('assets/html/budgetStandBy.html')
        : await rootBundle.loadString('assets/html/budgetModeUse.html');

    file = file.replaceFirst('orcamentoText', budgetModel.budgetCode ?? '');
    file = file.replaceFirst('nomeClienteText', budgetModel.clientName ?? '');
    file = file.replaceFirst('cidadeClienteText', budgetModel.clientCity ?? '');
    file = file.replaceFirst('telefoneClienteText', budgetModel.clientPhone ?? '');
    file = file.replaceFirst('emailClienteText', budgetModel.clientEmail ?? '');

    // descrição gerador
    file = file.replaceFirst('geradorModoUsoText',
        budgetModel.generatorIsStandBy == 1 ? "MODO STANDY BY" : "MODO USO");
    file = file.replaceFirst('geradorKvaText', budgetModel.generatorKva ?? '');
    file = file.replaceFirst('geradorValueText', budgetModel.generatorValue ?? '');
    file = file.replaceFirst(
        'geradorOperatorValueText', budgetModel.generatorOperatorValue ?? '');
    file = file.replaceFirst(
        'geradorTotalValue',
        _totalValue(
                budgetModel.generatorOperatorValue ?? '0', budgetModel.generatorValue ?? '0')
            .toString());

    file = file.replaceFirst(
        'generatorObservationText',
        budgetModel.generatorObservation ?? ' ');

    //dados evento
    file = file.replaceFirst('eventoLocalText', budgetModel.eventLocal ?? '');
    if (budgetModel.generatorIsStandBy == 1) {
      file = file.replaceFirst(
          'eventoHoraAdicionalText', budgetModel.eventAdditionalhour ?? '');
    }
    file = file.replaceFirst('eventoDataInicio', budgetModel.eventDateStart ?? '');

    if (budgetModel.generatorIsStandBy == 0) {
      file = file.replaceFirst('eventoHoraUsoText', budgetModel.eventHoursUsed ?? '');
    }

    //forma pagamento
    file = file.replaceFirst('formaPagamentoTextValue', budgetModel.paymentType ?? '');

    // validade orçamento
    file = file.replaceFirst(
        'dataLimiteOrcamento',
        DateFormat.yMMMMd("pt_BR")
            .format(DateTime.now().add(Duration(days: 30)))
            .toUpperCase());

    file = file.replaceFirst(
        'dataOrcamento', DateFormat.yMMMMd("pt_BR").format(DateTime.now()));
    return file;
  } catch (e) {
    return 'error';
  }
}

double _totalValue(String firstValue, String secondValue) {
  var first = double.tryParse(firstValue) ?? 0.0;
  var second = double.tryParse(secondValue) ?? 0.0;

  return (first + second);
}
