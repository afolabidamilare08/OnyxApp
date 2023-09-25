class AddBankModel {
  String bankName;
  String accountNumber;
  String accountName;
  // String accountName;
  AddBankModel(
      {required this.bankName,
      required this.accountNumber,
      required this.accountName});
  // factory AddBankModel.fromJson(Map<String,dynamic>json){
  //   return AddBankModel(bankName: json['bankName'], accountNumber: json['accountNumber'],);
  // }
}
