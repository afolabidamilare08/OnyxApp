import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:onyxswap/data/local/local_cache/local_cache.dart';
import 'package:onyxswap/models/chatMessgaeModel.dart';
import 'package:onyxswap/models/exceptions.dart';
import 'package:onyxswap/utils/color.dart';
import 'package:onyxswap/utils/locator.dart';
import 'package:onyxswap/utils/text.dart';
import 'package:onyxswap/views/support/components/chatTextField.dart';
import 'package:onyxswap/views/support/components/messageCard.dart';
import 'package:onyxswap/views/support/viewmodel/supportmixin.dart';
import 'package:onyxswap/views/support/viewmodel/supportviewmodel.dart';
import 'package:onyxswap/widgets/flushbar.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final supportViewmodel = ChangeNotifierProvider.autoDispose<SupportViewmodel>(
    (ref) => SupportViewmodel());

class SupportView extends ConsumerStatefulWidget {
  const SupportView({Key? key}) : super(key: key);

  @override
  ConsumerState<SupportView> createState() => _SupportViewState();
}

// this is a temporary list of messages
LocalCache _localCache = locator<LocalCache>();
List<ChatMessage> messages = [ChatMessage(messageContent: 'Hi ${_localCache.getFromLocalCache('firstname')??'There'.toString()},How Can we help?', messageType: 'receiver', sentat:'')];
TextEditingController message = TextEditingController();

class _SupportViewState extends ConsumerState<SupportView> {
  late IO.Socket socket;
  ScrollController scrollController = ScrollController();
  scrollToBottom() {
    if (scrollController.hasClients) {
      print('scrolled');
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    }
  }

  // List<Word> temp = (jsonMap['data'] as List).map((itemWord) => Word.fromJson(itemWord)).toList();
  
  bool reconnect = false;
  bool connected = false;
  void connect() {
    String? userid = _localCache.getToken();
    print(userid);
    socket = IO.io(
        'https://onyxsupport.herokuapp.com',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setQuery({'userid': userid})
            .build());
    socket.connect();
    socket.onConnect((data) {
      print(data);
      scrollToBottom();
      setState(() {
        
      });
      socket.on('result', (data) {
        setState(() {
          messages.addAll(
              (data as List).map((item) => ChatMessage.fromJson(item)).toList());
          _localCache.saveToLocalCache(key: 'chat', value: data);
          scrollToBottom();
          setState(() {});
          print(messages);
        });
      });

      connected = true;
      setState(() {});
      if (mounted) {
        OnyxFlushBar.showSuccess(context: context, message: 'Connected');
      }
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      setState(() {});
    });
    socket.on('message', (data) {
      print(data);
      setState(() {
        messages.add(ChatMessage.fromJson(data));
      });
      scrollToBottom();
      setState(() {});
    });
    socket.onReconnect((data) {
      reconnect = true;
      setState(() {});
    });
    socket.onConnecting((data) {
      reconnect = false;
      setState(() {});
    });
    socket.onConnectError((data) {
      if (mounted) {
        setState(() {
          if (_localCache.getFromLocalCache('chat') != null) {
            messages = (_localCache.getFromLocalCache('chat') as List)
                .map((e) => ChatMessage.fromJson(e))
                .toList();
            print(messages);
          }
        });
      }
      // if (mounted) {
      //   OnyxFlushBar.showFailure(
      //       context: context,
      //       failure:
      //           UserDefinedException('ConnectionError', 'Connection $data'));
      // }
      // socket.onConnectTimeout((data) => null)
    });
    socket.onDisconnect((data) {
      if (_localCache.getFromLocalCache('chat') != null) {
        messages = (_localCache.getFromLocalCache('chat') as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList();
        setState(() {});
        print(messages);
      }
    });

    //socket.emit('connection', {'userid': userid});
  }

  sendMessage(String messages) {
    socket.emit('message', {'message': messages});
    // if(socket.on('error',(data) {

    // }))
    message.clear();
  }

  @override
  void initState() {
    super.initState();
    //Future.delayed(Duration.zero, ref.read(supportViewmodel).getMessages);

    print('object');
    setState(() {
      if (_localCache.getFromLocalCache('chat') != null) {
        messages = (_localCache.getFromLocalCache('chat') as List)
            .map((e) => ChatMessage.fromJson(e))
            .toList();
        print(messages);
      }
    });

    //getMessages();
    connect();
    // if(scrollController.hasClients)
    //  scrollController.animateTo(scrollController.position.maxScrollExtent,
    //       duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    //       setState(() {

    //       });
    scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColorfulSafeArea(
        color: const Color(0xff373837),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 10),
                    width: double.infinity,
                    color: const Color(0xff373837),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          clipBehavior: Clip.hardEdge,
                          width: 38,
                          height: 38,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "https://images.pexels.com/photos/2050994/pexels-photo-2050994.jpeg",
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.heading2L("Admin"),
                            const SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 3,
                                ),
                                AppText.body4L("Chat"),
                              ],
                            ),
                            reconnect
                                ? AppText.body4L(
                                    "Reconneting........",
                                    color: Colors.red,
                                  )
                                : connected
                                    ? SizedBox()
                                    : AppText.body3L(
                                        'Connecting......',
                                        color: kSuccessColor,
                                      )
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.more_vert_rounded,
                              color: kSecondaryColor,
                            ))
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            // AppText.body4P(
                            //   "Yesterday - 10:30AM",
                            //   centered: true,
                            // ),
                            const SizedBox(
                              height: 20,
                            ),
                            ...List.generate(
                              messages.length,
                              (index) => messages.isEmpty
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                          child: Lottie.asset(
                                              "assets/lotties/loader.json",
                                              height: 40,
                                              width: 40)))
                                  : MessgaeCard(
                                      messages: messages, index: index),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                  ChatTextField(
                    message: message,
                    onTFTap: ()=>scrollToBottom(),
                    onTap: () => sendMessage(message.text),
                  )
                ],
              ),
            ),
            // BackdropFilter(
            //     filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            //     child: Container(
            //       color: Colors.transparent,
            //       child: Center(
            //           child: AppText.heading1N(
            //         'COMING SOON',
            //         color: kSecondaryColor,
            //       )),
            //     ))
          ],
        ),
      ),
    );
  }
}
