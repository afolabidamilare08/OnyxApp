// ignore_for_file: file_names

import 'package:intl/intl.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/utils/locator.dart';
 final LocalCache localCache = locator<LocalCache>();
  String? userid = localCache.getToken();
class ChatMessage {
  String messageContent;
  String messageType;
  String sentat;
 
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.sentat});
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    DateTime timesent = DateTime.fromMillisecondsSinceEpoch(
        int.tryParse(json['createdDate'].toString()) ?? 0 * 1000);
    
    return ChatMessage(
        messageContent: json['message'],
        messageType: json['fromWho'] == userid ? 'sender' : 'receiver',
        sentat: DateFormat.jm().format(timesent));
  }
}
