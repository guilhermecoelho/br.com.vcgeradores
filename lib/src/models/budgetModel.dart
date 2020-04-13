class BudgetModel {

  final int id;
  String budgetCode = '';
  String budgetTotalValue = '';
  String budgetDate = '';

  //client
  final String clientName;
  String clientCity = '';
  String clientPhone = '';
  String clientEmail = '';

  //generator
  String generatorKva = '';
  String generatorValue = '';
  String generatorOperatorValue = '';

  //event
  String eventLocal = '';
  String eventAdditionalhour = '';
  String eventDateStart = '';
  String eventDateEnd = '';

  //payment
  String paymentType = '';

  BudgetModel({this.id, this.clientName});

  Map<String, dynamic> toMap() {
    return {'id': id, 'clientName': clientName};
  }
}