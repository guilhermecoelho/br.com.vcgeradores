import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/sidebar.dart';


class CreateBudget extends StatelessWidget {
  final orcamentoText = TextEditingController();
  final nomeClienteText = TextEditingController();
  //final enderecoClienteText = TextEditingController();
  final cidadeClienteText = TextEditingController();
  //final estadoClienteText = TextEditingController();
  final telefoneClienteText = TextEditingController();
  final emailClienteText = TextEditingController();

  //descrição gerador
  final geradorKvaText = TextEditingController();
  final geradorValueText = TextEditingController();
  final geradorOperatorValueText = TextEditingController();

  //dados evento
  final eventoLocalText = TextEditingController();
  final eventoHoraAdicionalText = TextEditingController();

  //forma de pagamento
  final formaPagamentoTextValue = TextEditingController();

  double totalValue(String firstValue, String secondValue) {
    var first = double.tryParse(firstValue);
    var second = double.tryParse(secondValue);

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
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Código Orçamento"),
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
                    controller: telefoneClienteText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Email Cliente"),
                    controller: emailClienteText,
                  ),

                  //descrição gerador
                  TextFormField(
                    decoration: const InputDecoration(labelText: "KVA gerador"),
                    controller: geradorKvaText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Valor gerador"),
                    controller: geradorValueText,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Valor operador"),
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



Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/html/teste.html');
}

  Future<String> buildHTML() async {
    try {
      var file =  await rootBundle.loadString('assets/html/budget.html');

      // Read the file.
      file = file.replaceFirst('orcamentoText', orcamentoText.text);

      // return contents;
      return file;
    } catch (e) {
      // If encountering an error, return 0.
      return 'error';
    }
  }

  List<int> buildPdf(PdfPageFormat format) {
    final pdf.Document doc = pdf.Document();
    doc.addPage(pdf.MultiPage(
        pageFormat: format,
        build: (context) => [
              //Header
              pdf.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  '        ',
                  'VC geradores e locações\n'
                      'Rua Sibipiruna, n 94, Cond. Mirante do lenheiro\n'
                      'Cidade de Valinhos/SP - CEP 13272-162\n'
                      'Telefone (19)3327-4299 / 97407-9690',
                  'ORÇAMENTO\n' + orcamentoText.text
                ],
              ]),
              //Client
              pdf.Table.fromTextArray(
                  context: context,
                  data: const <List<String>>[
                    <String>['Dados do Cliente']
                  ]),
              pdf.Paragraph(text: 'Nome ' + nomeClienteText.text),
              pdf.Paragraph(text: 'Cidade ' + cidadeClienteText.text),
              pdf.Paragraph(text: 'Telefone ' + telefoneClienteText.text),
              pdf.Paragraph(text: 'E-mail ' + emailClienteText.text),
              //Equipaments
              pdf.Table.fromTextArray(
                  context: context,
                  data: const <List<String>>[
                    <String>[
                      'CARACTERISTICA(S) DO(S) EQUIPAMENTO(S) E ACESSÓRIO'
                    ]
                  ]),
              pdf.Table.fromTextArray(
                  context: context,
                  data: const <List<String>>[
                    <String>[
                      'Quantidade',
                      'Descrição',
                      ' ',
                      ' ',
                      'Valor Total'
                    ],
                    <String>[
                      '1',
                      'GERADOR CARENADO',
                      '120 KVa',
                      'MODO STAND BY',
                      '750.00'
                    ],
                    <String>[
                      '1',
                      'OPERADOR PLANTÃO PARA 8 HS',
                      '',
                      '',
                      '200.00'
                    ],
                    <String>['', '', '', '', ''],
                    <String>[
                      '1',
                      'CONJ CABOS TRIFASICOS/ INTERMEDIARIA',
                      '70 mm',
                      '',
                      'CORTESIA'
                    ],
                    <String>['1', 'TRANSPORTE', '', '', 'CORTESIA'],
                  ]),
              pdf.Paragraph(text: 'VALOR TOTAL LOCAÇÂO GERADOR: 950'),
              pdf.Paragraph(text: 'INDICES GERAIS DE LOCAÇÃO '),
              pdf.Paragraph(text: 'Quantidade: 1 MODO: STAND BY'),
              pdf.Paragraph(text: 'Finalidade: EVENTO '),
              pdf.Paragraph(
                  text:
                      'Local evento: ESPAÇO DE EVENTOS CASA PALMEIRA - VINHEDO '),
              pdf.Paragraph(text: 'Endereço evento: '),
              pdf.Paragraph(
                  text:
                      ' Periodo   Data inicio 27/03/2020 Data final 27/03/2020'),
              pdf.Paragraph(text: 'Valor hora Adicional: 95.00 '),
              pdf.Paragraph(
                  text:
                      'Hora Adicional: Será considerado hora adcional a partir do momento em que o gerador será acionado pelo operador por falta de energia elétrica externa (CPFL) '),
              // Includes
              pdf.Paragraph(text: 'INCLUSOS'),
              pdf.Paragraph(text: 'Combustivel:'),
              pdf.Paragraph(text: 'Entrega: Inclusa  Retirada: Inclusa'),
              pdf.Paragraph(text: 'Transporte/ pessoal/ despesas fiscais:'),
              // Condictions
              pdf.Paragraph(
                  text: 'Valor Locação 950,00 NOVECENTOS E CINQUENTA REAIS'),
              pdf.Paragraph(text: 'Condições de pagamento A COMBINAR'),
              pdf.Paragraph(text: 'Forma de pagamento  A COMBINAR'),
              pdf.Paragraph(text: 'ORÇAMENTO VALIDO ATÉ 30 DE MARÇO DE 2020'),
              pdf.Paragraph(text: 'Valinhos 09 DE MARÇODE 2020'),
              pdf.Paragraph(text: 'Vergilio de Jesus Coelho'),
              pdf.Paragraph(text: 'VC GERADORES E LOCAÇÕES'),
            ]));
    //Geral Information

    return doc.save();
  }
}
