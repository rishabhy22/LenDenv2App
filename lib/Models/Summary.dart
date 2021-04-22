class SummaryResponse {
  String status, error;
  int due;
  List<CashFlow> cashFlow = List<CashFlow>.empty(growable: true);

  SummaryResponse({this.status, this.error, this.due, this.cashFlow});

  SummaryResponse.fromJson(Map<String, dynamic> data) {
    this.status = data["status"];
    this.error = data["error"];
    this.due = data["data"]["due"];

    for (var cF in data["data"]["cash_flow"])
      this.cashFlow.add(CashFlow.fromJson(cF));
  }

  Map<String, dynamic> toJson() {
    return {
      "status": this.status,
      "error": this.error,
      "due": this.due,
      "cash_flow": this.cashFlow
    };
  }
}

class CashFlow {
  String from, to;
  int amount;

  CashFlow.fromJson(Map<String, dynamic> data) {
    this.from = data["from"];
    this.to = data["to"];
    this.amount = data["amount"];
  }

  Map<String, dynamic> toJson() {
    return {"from": this.from, "to": this.to, "amount": this.amount};
  }
}
