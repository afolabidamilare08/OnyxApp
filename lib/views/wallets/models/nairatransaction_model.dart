// To parse this JSON data, do
//
//     final NairaTransationModel = NairaTransationModelFromJson(jsonString);

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

NairaTransationModel nairaTransationModelFromJson(String str) =>
    NairaTransationModel.fromJson(json.decode(str));

String nairaTransationModelToJson(NairaTransationModel data) =>
    json.encode(data.toJson());

class NairaTransationModel {
  NairaTransationModel({
    required this.entity,
  });

  final Entity entity;

  factory NairaTransationModel.fromJson(Map<String, dynamic> json) =>
      NairaTransationModel(
        entity: Entity.fromJson(json["entity"]),
      );

  Map<String, dynamic> toJson() => {
        "entity": entity.toJson(),
      };
}

class Entity {
  Entity({
    required this.chargedFromWallet,
    required this.companyName,
    required this.dateCreated,
    required this.recipientAccountName,
    required this.recipientAccountNumber,
    required this.recipientBankCode,
    required this.recipientBankName,
    required this.senderAccountName,
    required this.senderAccountNumber,
    required this.senderBankName,
    required this.source,
    required this.transactionAmount,
    required this.transactionCharge,
    required this.transactionEventType,
    required this.transactionId,
    required this.transactionReason,
    required this.transactionRemarks,
    required this.transactionStatus,
    required this.transactionType,
    required this.walletBalanceAfter,
    required this.walletBalanceBefore,
    required this.walletId,
  });

  final bool chargedFromWallet;
  final String companyName;
  final DateTime dateCreated;
  final String recipientAccountName;
  final String recipientAccountNumber;
  final String recipientBankCode;
  final String recipientBankName;
  final String senderAccountName;
  final String senderAccountNumber;
  final String senderBankName;
  final String source;
  final double transactionAmount;
  final double transactionCharge;
  final String transactionEventType;
  final String transactionId;
  final dynamic transactionReason;
  final String transactionRemarks;
  final String transactionStatus;
  final String transactionType;
  final double walletBalanceAfter;
  final double walletBalanceBefore;
  final String walletId;

  factory Entity.fromJson(Map<String, dynamic> json) {
    DateTime timesent = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['date_created'].toString()) ?? 0 * 1000);
    return Entity(
      chargedFromWallet: json["charged_from_wallet"],
      companyName: json["company_name"],
      dateCreated:DateTime.parse(json['date_created']),
      recipientAccountName: json["recipient_account_name"],
      recipientAccountNumber: json["recipient_account_number"],
      recipientBankCode: json["recipient_bank_code"],
      recipientBankName: json["recipient_bank_name"],
      senderAccountName: json["sender_account_name"],
      senderAccountNumber: json["sender_account_number"],
      senderBankName: json["sender_bank_name"],
      source: json["source"],
      transactionAmount: double.tryParse(json["transaction_amount"].toString())!,
      transactionCharge: double.tryParse(json["transaction_charge"].toString())!,
      transactionEventType: json["transaction_event_type"],
      transactionId: json["transaction_id"],
      transactionReason: json["transaction_reason"],
      transactionRemarks: json["transaction_remarks"],
      transactionStatus: json["transaction_status"],
      transactionType: json["transaction_type"],
      walletBalanceAfter: double.tryParse(json["wallet_balance_after"].toString())!,
      walletBalanceBefore:double.tryParse(  json["wallet_balance_before"].toString())!,
      walletId: json["wallet_id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "charged_from_wallet": chargedFromWallet,
        "company_name": companyName,
        "date_created": dateCreated.toIso8601String(),
        "recipient_account_name": recipientAccountName,
        "recipient_account_number": recipientAccountNumber,
        "recipient_bank_code": recipientBankCode,
        "recipient_bank_name": recipientBankName,
        "sender_account_name": senderAccountName,
        "sender_account_number": senderAccountNumber,
        "sender_bank_name": senderBankName,
        "source": source,
        "transaction_amount": transactionAmount,
        "transaction_charge": transactionCharge,
        "transaction_event_type": transactionEventType,
        "transaction_id": transactionId,
        "transaction_reason": transactionReason,
        "transaction_remarks": transactionRemarks,
        "transaction_status": transactionStatus,
        "transaction_type": transactionType,
        "wallet_balance_after": walletBalanceAfter,
        "wallet_balance_before": walletBalanceBefore,
        "wallet_id": walletId,
      };
}
