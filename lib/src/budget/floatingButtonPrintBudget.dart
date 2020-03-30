import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:vc_geradores/src/budget/createBudget.dart';

class FloatingButtonPrintBudget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: const Icon(Icons.print),
      tooltip: 'Imprimir',
      onPressed: () {
        Printing.layoutPdf(
          onLayout: CreateBudget().buildPdf,
        );
      },
    );
  }
}
