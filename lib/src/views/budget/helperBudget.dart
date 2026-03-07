import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/models/budgetModel.dart';


const PdfColor _darkNavy = PdfColor.fromInt(0xFF1A1A2E);
const PdfColor _mediumGray = PdfColor.fromInt(0xFF4A4A6A);
const PdfColor _lightGray = PdfColor.fromInt(0xFFF0F4F8);
const PdfColor _borderGray = PdfColor.fromInt(0xFFCCCCCC);
const PdfColor _accentRed = PdfColor.fromInt(0xFFE53935);
const PdfColor _yellow = PdfColor.fromInt(0xFFFFFF00);
const PdfColor _lightYellow = PdfColor.fromInt(0xFFFFF9C4);
const PdfColor _lightGreen = PdfColor.fromInt(0xFFE8F5E9);
const PdfColor _green = PdfColor.fromInt(0xFF388E3C);
const PdfColor _white = PdfColors.white;

const logo = "logo";

Future<void> printPdf(BudgetModel budgetModel) async {
  final String htmlContent = await _buildHTML(budgetModel);

  await Printing.layoutPdf(
    onLayout: (format) => Printing.convertHtml(
      html: htmlContent,
      format: format,
    ),
  );
}
pw.Widget _header(BudgetModel d) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _darkNavy, width: 2),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          //logo
         pw.Container(
            width: 80,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                right: pw.BorderSide(color: _darkNavy, width: 1),
              ),
            ),
            padding: const pw.EdgeInsets.all(8),
            child: logo != null
                ? pw.Center(
                    //child: pw.Image(logo, fit: pw.BoxFit.contain),
                    child: pw.Text(logo)
                  )
                : pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        // Placeholder icon built from basic shapes
                        pw.Container(
                          width: 48,
                          height: 48,
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            border: pw.Border.all(color: _darkNavy, width: 2),
                          ),
                          child: pw.Center(
                            child: pw.Text(
                              'VC',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                                color: _darkNavy,
                              ),
                            ),
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'LOGO',
                          style: pw.TextStyle(
                            fontSize: 7,
                            color: _mediumGray,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          // Company info
          pw.Expanded(
            flex: 3,
            child: pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                  right: pw.BorderSide(color: _darkNavy, width: 1),
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'VCGERADORES E LOCAÇÕES',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: _darkNavy,
                      letterSpacing: 0.5,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Rua Sibipiruna, 94, Cond. Mirante Lenheiro\n'
                    'Cidade de Valinhos/ SP - CEP 13.272-162\n'
                    'Telefone (19)3327-4299 - 97407-9690\n'
                    'CNPJ 19.731.581/0001-60',
                    style: pw.TextStyle(fontSize: 8, color: _mediumGray, lineSpacing: 2),
                  ),
                ],
              ),
            ),
          ),
          // Orçamento number
          pw.Expanded(
            flex: 2,
            child: pw.Container(
              padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'ORÇAMENTO',
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: _mediumGray,
                      letterSpacing: 2,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    d.budgetCode!,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: _darkNavy,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

pw.Widget _clientSection(BudgetModel d) {
    return _section(
      title: 'DADOS DO CLIENTE',
      child: pw.Column(
        children: [
          _infoRow('Nome', d.clientName!),
          _infoRow('Cidade', d.clientCity!),
          _infoRow('Telefone', d.clientPhone!),
          _infoRow('E-mail', d.clientEmail!, valueColor: PdfColors.blue),
        ],
      ),
    );
  }

pw.Widget _equipmentSection(BudgetModel d) {
    return _section(
      title: 'CARACTERÍSTICA(S) DO(S) EQUIPAMENTO(S) E ACESSÓRIOS',
      child: pw.Table(
        border: pw.TableBorder.all(color: _borderGray, width: 0.5),
        columnWidths: const {
          0: pw.FixedColumnWidth(30),
          1: pw.FlexColumnWidth(4),
          2: pw.FlexColumnWidth(2),
          3: pw.FlexColumnWidth(2),
          4: pw.FlexColumnWidth(2),
        },
        children: [
          // Header row
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: _lightGray),
            children: [
              _tableHeaderCell('Qtd'),
              _tableHeaderCell('Descrição'),
              _tableHeaderCell('Especif.'),
              _tableHeaderCell('Modo Uso', bgColor: _yellow),
              _tableHeaderCell('Valor Total'),
            ],
          ),
          // Generator
          _equipmentTableRow(
            qty: '1',
            description: 'GERADOR CARENADO',
            spec: '${d.generatorKva} KVA',
            modeUso: d.generatorIsStandBy.toString(),
            value: d.generatorValue!,
            modeHighlighted: true,
          ),
          // Operator
          _equipmentTableRow(
            qty: '1',
            description: 'OPERADOR PLANTÃO',
            spec: '',
            modeUso: '',
            value: d.generatorOperatorValue!,
          ),
          // Cables
          _equipmentTableRow(
            qty: '1',
            description: 'CONJ CABOS TRIFÁSICOS / INTERMEDIÁRIA',
            spec: '70 MM',
            modeUso: '',
            value: 'CORTESIA',
            valueGreen: true,
          ),
          // Transport
          _equipmentTableRow(
            qty: '1',
            description: 'TRANSPORTE',
            spec: '',
            modeUso: '',
            value: 'CORTESIA',
            valueGreen: true,
          ),
        ],
      ),
    );
  }

pw.Widget _totalRow(BudgetModel d) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text(
          'VALOR TOTAL LOCAÇÃO GERADOR',
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: pw.FontWeight.bold,
            color: _mediumGray,
          ),
        ),
        pw.SizedBox(width: 12),
        pw.Text(
          d.generatorTotalValue.toString(),
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            fontStyle: pw.FontStyle.italic,
            color: _accentRed,
          ),
        ),
      ],
    );
  }

pw.Widget _rentalIndexSection(BudgetModel d) {
    return _section(
      title: 'ÍNDICES GERAIS DE LOCAÇÃO',
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _infoRow('Finalidade', 'EVENTO'),
          _infoRow('Local evento', d.eventLocal!),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              pw.Text('Período', style: pw.TextStyle(fontSize: 9, color: _mediumGray)),
              pw.SizedBox(width: 8),
              pw.Text('Data Inicial ', style: pw.TextStyle(fontSize: 9, color: _mediumGray)),
              pw.Text(
                d.eventDateStart.toString(),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: _accentRed,
                ),
              ),
              pw.SizedBox(width: 12),
              pw.Text('Data Final ', style: pw.TextStyle(fontSize: 9, color: _mediumGray)),
              pw.Text(
                d.eventDateEnd.toString(),
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: _accentRed,
                ),
              ),
            ],
          ),
          if (d.eventHoursUsed == null) ...[
            pw.SizedBox(height: 4),
            _infoRow('Hora Adicional', d.eventHoursUsed.toString()),
          ],
          if (d.generatorObservation == null) ...[
            pw.SizedBox(height: 4),
            _infoRow('Observações', d.generatorObservation.toString()),
          ],
        ],
      ),
    );
  }

pw.Widget _paymentRow(BudgetModel d) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Forma de pagamento:',
          style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: _darkNavy),
        ),
        pw.SizedBox(width: 8),
        pw.Expanded(
          child: pw.Text(
            d.paymentType!,
            style: pw.TextStyle(fontSize: 9, color: _darkNavy),
          ),
        ),
      ],
    );
  }

pw.Widget _validityBanner(BudgetModel d) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _darkNavy, width: 2),
        color: _lightGray,
      ),
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: pw.Text(
        'ORÇAMENTO VÁLIDO ATÉ ${d.budgetDate}',
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          fontStyle: pw.FontStyle.italic,
          color: _darkNavy,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

pw.Widget _footerRow(BudgetModel d) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          'Valinhos, ${d.budgetDate}',
          style: pw.TextStyle(fontSize: 9, color: _mediumGray),
        ),
        pw.Spacer(),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(width: 180, height: 0.5, color: _darkNavy),
            pw.SizedBox(height: 3),
            pw.Text(
              'Assinatura / Aprovação',
              style: pw.TextStyle(fontSize: 8, color: _mediumGray),
            ),
          ],
        ),
      ],
    );
  }

pw.Widget _infoRow(String label, String value, {PdfColor? valueColor}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 70,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 9, color: _mediumGray),
            ),
          ),
          pw.SizedBox(width: 6),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 9,
                fontWeight: pw.FontWeight.bold,
                color: valueColor ?? _darkNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

pw.Widget _section({required String title, required pw.Widget child}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          color: _lightGray,
          padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 8,
              color: _darkNavy,
              letterSpacing: 0.8,
            ),
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(10),
          child: child,
        ),
      ],
    );
  }

pw.Widget _tableHeaderCell(String text, {PdfColor? bgColor}) {
    return pw.Container(
      color: bgColor,
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 8,
          color: _darkNavy,
        ),
      ),
    );
  }

pw.Widget _inclusosSection() {
    const items = [
      ('Combustível', true),
      ('Entrega', true),
      ('Retirada', true),
      ('Transporte / pessoal / despesas fiscais', false),
    ];

    return _section(
      title: 'INCLUSOS',
      child: pw.Table(
        border: pw.TableBorder.all(color: _borderGray, width: 0.5),
        columnWidths: const {
          0: pw.FlexColumnWidth(5),
          1: pw.FixedColumnWidth(60),
        },
        children: [
          pw.TableRow(
            decoration: const pw.BoxDecoration(color: _lightGray),
            children: [
              _tableHeaderCell('Item'),
              _tableHeaderCell('Incluído'),
            ],
          ),
          for (final item in items)
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: item.$2 ? _lightGreen : null,
              ),
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: pw.Text(item.$1, style: pw.TextStyle(fontSize: 8)),
                ),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  child: pw.Text(
                    item.$2 ? 'X' : '',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: item.$2 ? _green : PdfColors.white,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

pw.TableRow _equipmentTableRow({
    required String qty,
    required String description,
    required String spec,
    required String modeUso,
    required String value,
    bool modeHighlighted = false,
    bool valueGreen = false,
  }) {
    return pw.TableRow(children: [
      _tableDataCell(qty, align: pw.TextAlign.center),
      _tableDataCell(description),
      _tableDataCell(spec, align: pw.TextAlign.center),
      pw.Container(
        color: modeHighlighted ? _lightYellow : null,
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        child: pw.Text(
          modeUso,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: modeHighlighted ? pw.FontWeight.bold : pw.FontWeight.normal,
            fontStyle: modeHighlighted ? pw.FontStyle.italic : pw.FontStyle.normal,
          ),
        ),
      ),
      pw.Container(
        color: valueGreen ? _lightGreen : null,
        padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontSize: 8,
            fontWeight: valueGreen ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: valueGreen ? _green : _darkNavy,
          ),
        ),
      ),
    ]);
  }

  pw.Widget _tableDataCell(String text, {pw.TextAlign align = pw.TextAlign.left}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: pw.Text(
        text,
        textAlign: align,
        style: pw.TextStyle(fontSize: 8, color: _darkNavy),
      ),
    );
  }

Future<pw.Document> printPdf2(BudgetModel budgetModel) async {
  final pdf = pw.Document();
  
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _header(budgetModel),
            pw.SizedBox(height: 6),
            _clientSection(budgetModel),
            pw.SizedBox(height: 6),
             _equipmentSection(budgetModel),
            pw.SizedBox(height: 4),
            _totalRow(budgetModel),
             pw.SizedBox(height: 6),
            _rentalIndexSection(budgetModel),
             pw.SizedBox(height: 6),
            _inclusosSection(),
             pw.SizedBox(height: 6),
            _paymentRow(budgetModel),
            pw.SizedBox(height: 8),
            _validityBanner(budgetModel),
             pw.SizedBox(height: 8),
            _footerRow(budgetModel)
          ]
      )
    )
  );
    return pdf;
}

Future<void> preview(BuildContext context, pw.Document pdf) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("preview"),
      content: Container(
        width: double.maxFinite,
        height: 400,
        child: PdfPreview(
          build: (format) => pdf.save(),
          allowSharing: true,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("close"),
        )
      ],
    )
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

