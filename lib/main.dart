import 'package:flutter/material.dart';
import 'package:vc_geradores/src/views/budget/createBudget.dart';
import 'package:vc_geradores/src/views/budget/listBudget.dart';
import 'package:intl/date_symbol_data_local.dart';



void main() => initializeDateFormatting('pt_BR', null).then((_) =>  runApp(ListBudget()));
