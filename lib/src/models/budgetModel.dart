class BudgetModel {
  int id;
  String budgetCode;
  String budgetTotalValue;
  String budgetDate;

  //client
  String clientName;
  String clientCity;
  String clientPhone;
  String clientEmail;

  //generator
  String generatorKva;
  String generatorValue;
  String generatorOperatorValue;
  String generatorTotalValue;

  //event
  String eventLocal;
  String eventAdditionalhour;
  String eventDateStart;
  String eventDateEnd;

  //payment
  String paymentType;

  BudgetModel(
      {this.id,
      this.budgetCode,
      this.budgetTotalValue,
      this.budgetDate,
      this.clientName,
      this.clientCity,
      this.clientPhone,
      this.clientEmail,
      this.generatorKva,
      this.generatorValue,
      this.generatorOperatorValue,
      this.generatorTotalValue,
      this.eventLocal,
      this.eventAdditionalhour,
      this.eventDateStart,
      this.eventDateEnd,
      this.paymentType});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'budgetCode': budgetCode,
      'budgetTotalValue': budgetTotalValue,
      'budgetDate': budgetDate,
      'clientName': clientName,
      'clientCity': clientCity,
      'clientPhone': clientPhone,
      'clientEmail': clientEmail,
      'generatorKva': generatorKva,
      'generatorValue': generatorValue,
      'generatorOperatorValue': generatorOperatorValue,
      'generatorTotalValue': generatorTotalValue,
      'eventLocal': eventLocal,
      'eventAdditionalhour': eventAdditionalhour,
      'eventDateStart': eventDateStart,
      'eventDateEnd': eventDateEnd,
      'paymentType': paymentType
    };
  }
}
