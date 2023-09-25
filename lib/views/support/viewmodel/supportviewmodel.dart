import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onyxswap/models/failure.dart';
import 'package:onyxswap/models/view_model_states/view_model_state.dart';
import 'package:onyxswap/utils/network_client.dart';
import 'package:onyxswap/views/support/viewmodel/supportmixin.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:onyxswap/widgets/flushbar.dart';

import '../../../core/services/navigation_service.dart';
import '../../../data/local/local_cache/local_cache.dart';
import '../../../models/chatMessgaeModel.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../utils/locator.dart';

class SupportViewmodel extends BaseViewModel with SupportMixin {
  List<ChatMessage> apiMessgaes = [];
  final NetworkClient _networkClient = NetworkClient();
  initialise() async {
    try {
      changeState(ViewModelState.busy());
      initialiseSocketcallback();
      while (!socket.connected) {
        socket.connect();
        await Future.delayed(const Duration(seconds: 3));
      }
      changeState(const ViewModelState.idle());
    } on Failure catch (failure) {
      OnyxFlushBar.showError(title: '', message: 'Something went wrong');
      changeState(ViewModelState.error(failure));
      NavigationService.I.goBack();
    }
  }

  getMessages() async {
    changeState(ViewModelState.busy());
    _networkClient.post('/getchats',
        body: FormData.fromMap({'userid': userid}));
    apiMessgaes = (_networkClient.data as List)
        .map((e) => ChatMessage.fromJson(e))
        .toList();
    changeState(ViewModelState.idle());
    print(apiMessgaes);
  }
//TextEditingController message = TextEditingController();

  // late IO.Socket socket;
  // // List<Word> temp = (jsonMap['data'] as List).map((itemWord) => Word.fromJson(itemWord)).toList();
  // LocalCache _localCache = locator<LocalCache>();

  // void connect() {
  //   String? userid = _localCache.getToken();
  //   print(userid);
  //   socket = IO.io(
  //       'http://10.0.2.2:3000',
  //       IO.OptionBuilder()
  //           .setTransports(['websocket']).setQuery({'userid': userid}).build());
  //   //socket.onConnect((data) => print('connected'));
  //   socket.onConnectError((data) {
  //     if (_localCache.getFromLocalCache('chat') != null) {
  //       messages = (_localCache.getFromLocalCache('chat') as List)
  //           .map((e) => ChatMessage.fromJson(e))
  //           .toList();
  //       print(messages);
  //     }
  //     notifyListeners();

  //     // if (mounted) {
  //     //   OnyxFlushBar.showFailure(
  //     //       context: context,
  //     //       failure:
  //     //           UserDefinedException('ConnectionError', 'Connection $data'));
  //     // }
  //     // socket.onConnectTimeout((data) => null)
  //   });
  //   socket.onDisconnect((data) {
  //     if (_localCache.getFromLocalCache('chat') != null) {
  //       messages = (_localCache.getFromLocalCache('chat') as List)
  //           .map((e) => ChatMessage.fromJson(e))
  //           .toList();

  //       print(messages);
  //     }
  //   });
  //   socket.on('result', (data) async* {
  //     messages =
  //         (data as List).map((item) => ChatMessage.fromJson(item)).toList();
  //     await _localCache.saveToLocalCache(key: 'chat', value: data);
  //     print(_localCache.getFromLocalCache('chat'));
  //     messages.reversed;
  //     notifyListeners();
  //   });

  //   socket.on('message', (data) {
  //     print(data);

  //     messages.add(ChatMessage.fromJson(data));
  //   });
  //   notifyListeners();
  //   //socket.emit('connection', {'userid': userid});
  // }

  // sendMessage(TextEditingController messages) {
  //   socket.emit('message', {'message': messages.text});
  //   messages.clear();
  // }

  // SupportViewmodel() {
  //   connect();
  //   print(_localCache.getFromLocalCache('chat'));
  //   if (_localCache.getFromLocalCache('chat') != null) {
  //     messages = (_localCache.getFromLocalCache('chat') as List)
  //         .map((e) => ChatMessage.fromJson(e))
  //         .toList();
  //     print(messages);
  //     notifyListeners();
  //   }
  // }
}
