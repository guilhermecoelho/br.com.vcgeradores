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
  int generatorIsStandBy;
  String generatorObservation;

  //event
  String eventLocal;
  String eventAdditionalhour;
  String eventHoursUsed;
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
      this.generatorIsStandBy,
      this.generatorObservation,
      this.eventLocal,
      this.eventAdditionalhour,
      this.eventHoursUsed,
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
      'generatorIsStandBy': generatorIsStandBy,
      'generatorObservation':generatorObservation,
      'eventLocal': eventLocal,
      'eventAdditionalhour': eventAdditionalhour,
      'eventHoursUsed': eventHoursUsed,
      'eventDateStart': eventDateStart,
      'eventDateEnd': eventDateEnd,
      'paymentType': paymentType
    };
  }
}
