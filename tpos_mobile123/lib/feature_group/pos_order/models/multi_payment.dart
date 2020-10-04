class MultiPayment {
  MultiPayment(
      {this.amountTotal,
      this.amountPaid,
      this.amountReturn,
      this.amountDebt,
      this.accountJournalId});
  double amountTotal;
  double amountPaid;
  double amountReturn;
  double amountDebt;
  int accountJournalId;
}
