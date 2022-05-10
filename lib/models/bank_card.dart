class BankCard {
  String number;
  String cvv;
  String activeTo;
  int sum;

  BankCard();

  bool isValid(){
    return
      number != null && number.length == 12 &&
    cvv != null && cvv.length == 3 &&
    activeTo != null && activeTo.length == 5 && activeTo.substring(2,3) == '/' &&
    sum != null;
  }
}