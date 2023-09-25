
import 'dart:convert';

SendModel sendModelFromJson(String str) => SendModel.fromJson(json.decode(str));

String sendModelToJson(SendModel data) => json.encode(data.toJson());

class SendModel {
    SendModel({
        //required this.status,
        required this.data,
    });

    //final String status;
    final String data;

    factory SendModel.fromJson(Map<String, dynamic> json) => SendModel(
        //status: json["status"],
        data: json["success"],
    );

    Map<String, dynamic> toJson() => {
        //"status": status,
        "success": data
    };
}

class Data {
    Data({
        required this.status,
        required this.amount,
        required this.uid,
        required this.assetType,
        required this.chain,
        required this.network,
        required this.fee,
        required this.description,
        required this.ref,
    });

    final String status;
    final String amount;
    final String uid;
    final String assetType;
    final String chain;
    final String network;
    final String fee;
    final dynamic description;
    final String ref;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        status: json["status"],
        amount: json["amount"],
        uid: json["uid"],
        assetType: json["assetType"],
        chain: json["chain"],
        network: json["network"],
        fee: json["fee"],
        description: json["description"],
        ref: json["ref"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "amount": amount,
        "uid": uid,
        "assetType": assetType,
        "chain": chain,
        "network": network,
        "fee": fee,
        "description": description,
        "ref": ref,
    };
}
