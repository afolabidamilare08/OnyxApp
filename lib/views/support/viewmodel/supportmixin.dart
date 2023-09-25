import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onyxswap/core/services/navigation_service.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/chatMessgaeModel.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/widgets/base_view_model.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../../widgets/flushbar.dart';

mixin SupportMixin on BaseViewModel {
  Socket get socket => _socket;
  late Socket _socket;
  LocalCache _localCache = locator<LocalCache>();
  NavigationService _navigationService=NavigationService.I;
    ScrollController scrollController = ScrollController();
  scrollToBottom() {
    if (scrollController.hasClients) {
      print('scrolled');
      scrollController.animateTo(scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }
  List<ChatMessage> messages = [];
  @override
  dispose() {
    log("========== Destorying socket =========");
    _socket.clearListeners();
    _socket.close();
    _socket.disconnect();
    _socket.destroy();
    _socket.dispose();
    super.dispose();
    log("========== End Destory =========");
  }

  initialiseSocketcallback() {
    String? userid = _localCache.getToken();
    _socket = io(
        'https://onyxsupport.herokuapp.com',
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({'userid': userid})
            .build());

    _socket.onError((data) {
      log('==onError==');
      print(data);
    });
    _socket.onReconnect((data) {
      log('reconnected');
    });
    _socket.onReconnecting((data) {
      log('reconnecting...');
    });
    _socket.onDisconnect((data) {
      log('onDisconnect');
    });
    _socket.onConnecting((data) {
      log('Conntecting...');
    });
    _socket.onReconnectAttempt((data) {
      log('onReconnectAttempt');
    });
    _socket.onConnectError((data) {
      log('==onConnectError==');
      print(data);
    });
    _socket.onReconnectError((data) {
      log('==onReconnectError==');
      print(data);
    });
    _socket.onConnect((data) {
      socket.on('result', (data) {
        messages =
            (data as List).map((item) => ChatMessage.fromJson(item)).toList();
        _localCache.saveToLocalCache(key: 'chat', value: data);

        print(messages);
          notifyListeners();
        scrollToBottom();
      
      });

     // connected = true;
      
      //if (mounted) {
        OnyxFlushBar.showSuccess(context: _navigationService.navigatorKey.currentState!.context, message: 'Connected');
     // }
    });
    _socket.onError((data) {
      log('==onError==');
      print(data);
    });
    _socket.connect();
  }
}
