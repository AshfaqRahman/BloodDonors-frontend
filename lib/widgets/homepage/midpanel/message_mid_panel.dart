import 'dart:async';
import 'dart:math';

import 'package:bms_project/modals/user_model.dart';
import 'package:bms_project/providers/chat_provider.dart';
import 'package:bms_project/providers/provider_response.dart';
import 'package:bms_project/providers/users_provider.dart';
import 'package:bms_project/utils/constant.dart';
import 'package:bms_project/utils/environment.dart';
import 'package:bms_project/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as sio;

import '../../../modals/chat_message_model.dart';
import '../../../modals/chat_model.dart';
import '../../../utils/debug.dart';
import '../../../utils/socket_events_util.dart';
import '../../common/profile_picture.dart';

class StreamSocket {
  static String TAG = "StreamSocket";
  final _socketResponse = StreamController<dynamic>();

  void addResponse(dynamic event) {
    Log.d(TAG, event);
    _socketResponse.sink.add(event);
  }

  Stream<dynamic> getResponse() {
    return _socketResponse.stream;
  }

  void dispose() {
    _socketResponse.close();
  }
}

class ChatMidPanel extends StatefulWidget {
  const ChatMidPanel({Key? key}) : super(key: key);
  @override
  State<ChatMidPanel> createState() => _ChatMidPanelState();
}

class _ChatMidPanelState extends State<ChatMidPanel> {
  static String TAG = "MyHomePage";

  late sio.Socket socket;

  StreamSocket streamSocket = StreamSocket();

  bool userId = true;

  // state variables
  Chat? activeChat = null; // currently acitve chat with wiche user is chating
  List<ChatMessage> messages = []; // messages

  // user search text
  String searchedUserName = "";

  ScrollController _messagListController = ScrollController();

  @override
  void initState() {
    super.initState();
    connectDartSocketClient();
  }

  void _activeChatChanged(Chat chat) {
    activeChat = chat; // change the active chat
    messages.clear();
    Provider.of<ChatProvider>(context, listen: false)
        .getMessages(activeChat!.userId)
        .then((ProviderResponse response) {
      if (response.success) {
        setState(() {
          messages = response.data;
        });
      }
    });
  }

  Future<void> _sendMessage(String msg) async {
    Log.d(TAG, "_sendMessage: $msg");
    String recieverId = activeChat?.userId ?? "";
    if (userId == "") {
      Log.d(TAG, "_sendMessage: to chat is selected as receiver");
      return;
    }

    ChatMessage chatMessage = ChatMessage(
        senderId: await AuthToken.parseUserId(),
        sender: await AuthToken.parseUserName(),
        receiver: activeChat!.userName,
        receiverId: recieverId,
        message: msg,
        sentTime: DateTime.now());
    streamSocket.addResponse(chatMessage.toJson());

    // send to server
    Log.d(TAG, "sending: ${chatMessage.toJson()}");
    socket.emit(SocketEvents.SEND_MESSAGE, chatMessage.toJson());
  }

  void _scrollToBottom() {
    _messagListController.animateTo(
        _messagListController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 50),
        curve: Curves.easeOut);
  }

  Future<List<UserSearhResult>> _searchUser(String userName) async {
    ProviderResponse response =
        await Provider.of<UsersProvider>(context, listen: false)
            .searchUser(userName);
    List<UserSearhResult> data = response.success ? response.data ?? [] : [];
    return data;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Flexible(
          //chat section
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(children: <Widget>[
              MyTextField(
                hint: "Search for people",
                vanishTextOnSubmit: false,
                onSubmitText: (String value) {
                  setState(() {
                    searchedUserName = value.trim();
                    if (searchedUserName != "") {
                      _searchUser(searchedUserName);
                    }
                  });
                },
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              ),
              const Divider(
                height: 15,
                thickness: 1,
              ),
              (searchedUserName != "")
                  ? Column(
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                searchedUserName = "";
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Text('Clear'),
                            )),
                        Divider(),
                        UserSearchListContainer(
                          query: searchedUserName,
                          onChatSelected: _activeChatChanged,
                        ),
                      ],
                    )
                  : ChatListContainer(
                      onChatSelected: _activeChatChanged,
                    )
            ]),
          ),
        ),
        const VerticalDivider(
          thickness: 1,
          width: 1,
        ),
        Flexible(
          //message section
          flex: 2,
          child: StreamBuilder(
            stream: streamSocket.getResponse(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              Log.d(TAG, snapshot.data);
              if (snapshot.hasData) {
                messages.insert(
                    0,
                    ChatMessage.fromJson(
                        snapshot.data as Map<String, dynamic>));
              }
              return Container(
                //  color: Colors.yellow,
                //padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                child: activeChat == null
                    ? const NoChatSelectedWidget()
                    : Column(
                        children: [
                          MessageContainerBarWidget(
                            activeChat: activeChat!,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: AuthToken.parseUserId(),
                              builder:
                                  (context, AsyncSnapshot<String> snapshot) {
                                String userId = snapshot.data ?? "";
                                if (userId == "") return Container();
                                return MessageContainer(
                                  messages: messages,
                                  messageListController: _messagListController,
                                  activeChat: activeChat!,
                                );
                              },
                            ),
                          ),
                          Container(
                            child: SendMessageContainer(
                              sendMessage: _sendMessage,
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  void connectDartSocketClient() {
    socket = Constants.getSocket();
    addSocketMessageListener();
  }

  void addSocketMessageListener() {
    socket.on(SocketEvents.RECEIVE_MESSAGE, (data) {
      Log.d(TAG, "addSocketMessageListener(): $data");
      streamSocket.addResponse(data);
      /* ChatMessage chatMessage = ChatMessage.fromJson(data);
      setState(() {
        Log.d(TAG, "message before: ${messages.length}");
        messages.insert(0, chatMessage);
        Log.d(TAG, "message now: ${messages.length}");
      }); */
    });
  }
}

class UserSearchListContainer extends StatelessWidget {
  static String TAG = "UserSearchListContainer";

  UserSearchListContainer({
    Key? key,
    required this.query,
    required this.onChatSelected,
  }) : super(key: key);

  final String query;
  final Function onChatSelected;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _searchUser(context, query),
      builder: ((context, AsyncSnapshot<List<UserSearhResult>> snapshot) {
        if (!snapshot.hasData ||
            snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        List<UserSearhResult>? result = snapshot.data;

        return result == null || result.isEmpty
            ? Text("No search result")
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  if (index == result.length) return Container();
                  UserSearhResult user = result[index];
                  return InkWell(
                    onTap: () {
                      Log.d(TAG, "selected user ${user.name} , id: ${user.id}");
                      onChatSelected(user.toChat());
                    },
                    child: ChatItem(chat: user.toChat()),
                  );
                }),
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: result.length + 1,
              );
      }),
    );
  }

  Future<List<UserSearhResult>> _searchUser(
      BuildContext context, String userName) async {
    ProviderResponse response =
        await Provider.of<UsersProvider>(context, listen: false)
            .searchUser(userName);
    Log.d(TAG, "UserSearhResult success: ${response.success}");
    List<UserSearhResult> data = response.success ? response.data ?? [] : [];
    return data;
  }
}

class MessageContainerBarWidget extends StatelessWidget {
  MessageContainerBarWidget({
    Key? key,
    required this.activeChat,
  }) : super(key: key);

  Chat activeChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0.0, 1.0), //(x,y)
          blurRadius: 2.0,
        ),
      ]),
      child: Row(children: [
        const SizedBox(
          width: 15,
        ),
        ProfilePictureFromName(
            name: activeChat.userName,
            radius: 20,
            fontsize: 15,
            characterCount: 2),
        const SizedBox(
          width: 15,
        ),
        Text(
          activeChat.userName,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}

class ChatListContainer extends StatefulWidget {
  const ChatListContainer({Key? key, required this.onChatSelected})
      : super(key: key);

  final Function onChatSelected;

  @override
  _ChatListContainerState createState() => _ChatListContainerState();
}

class _ChatListContainerState extends State<ChatListContainer> {
  static const String TAG = "ChatListContainer";

  List<Chat> chatList = [];

  @override
  Widget build(BuildContext context) {
    Log.d(TAG, "drawing total ${chatList.length}");
    return FutureBuilder(
      future: Provider.of<ChatProvider>(context, listen: false).getChats(),
      builder:
          (BuildContext context, AsyncSnapshot<ProviderResponse> snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();
        ProviderResponse response = snapshot.data!;
        if (!response.success) return const SizedBox.shrink();

        chatList = response.data;

        Log.d(TAG, "Chat list size: ${chatList.length}");

        return ListView.separated(
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            if (index == chatList.length) return Container();
            Chat chat = chatList[index];
            return InkWell(
              onTap: () {
                Log.d(
                    TAG, "selected user ${chat.userName} , id: ${chat.userId}");
                widget.onChatSelected(chat);
              },
              child: ChatItem(chat: chat),
            );
          }),
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: chatList.length + 1,
        );
      },
    );
  }
}

class ChatItem extends StatelessWidget {
  const ChatItem({
    Key? key,
    required this.chat,
  }) : super(key: key);

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
        ),
        ProfilePictureFromName(
          name: chat.userName,
          radius: 20,
          fontsize: 14,
          characterCount: 2,
          random: true,
        ),
        SizedBox(
          width: 20,
        ),
        Text(chat.userName)
      ],
    );
  }
}

class MessageContainer extends StatelessWidget {
  static const String TAG = "MessageContainer";
  List<ChatMessage> messages;
  Chat activeChat;

  MessageContainer({
    Key? key,
    required this.messages,
    required this.messageListController,
    required this.activeChat,
  }) : super(key: key);

  ScrollController messageListController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      reverse: true,
      controller: messageListController,
      itemCount: messages.length + 1,
      itemBuilder: (BuildContext context, int idx) {
        return idx != messages.length
            ? FutureBuilder(
                future: AuthToken.parseUserId(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return Container(); //const Center(child: CircularProgressIndicator());
                  }
                  return MessageItem(
                    chatMessage: messages[idx],
                    userId: snapshot.data!,
                  );
                },
              )
            : Container(
                height: 70,
              );
      },
    );
  }
}

class MessageItem extends StatelessWidget {
  ChatMessage chatMessage;

  MessageItem({Key? key, required this.userId, required this.chatMessage})
      : super(key: key);

  bool sentByMe = true;
  String userId;

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('dd MMM yyyy, hh:mma');
    TextTheme textTheme = Theme.of(context).textTheme;

    sentByMe = chatMessage.senderId == userId;
    Color msgTextColor = sentByMe ? Colors.white : Colors.black;
    Color timeTextColor = sentByMe ? Colors.white70 : Colors.black87;

    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: sentByMe ? Theme.of(context).primaryColor : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatMessage.message,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  ?.copyWith(color: msgTextColor),
            ),
            Text(
              dateFormat.format(chatMessage.sentTime.toLocal()),
              style: textTheme.labelSmall?.copyWith(
                  color: timeTextColor,
                  fontFamily: GoogleFonts.openSans().fontFamily,
                  letterSpacing: 0.02),
            )
          ],
        ),
      ),
    );
  }
}

class SendMessageContainer extends StatelessWidget {
  static String TAG = "SendMessageContainer";
  Function sendMessage;

  SendMessageContainer({
    Key? key,
    required this.sendMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: MyTextField(
        hint: "Write message",
        vanishTextOnSubmit: true,
        onSubmitText: (value) {
          if (value != "") {
            sendMessage(value);
          }
        },
        suffixIcon: const Icon(
          Icons.send,
          color: Colors.white,
        ),
      ),
    );
  }
}

class NoChatSelectedWidget extends StatelessWidget {
  const NoChatSelectedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Select a user to send message.",
        style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 20),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  static const String TAG = "MyTextField";
  MyTextField({
    Key? key,
    required this.hint,
    required this.onSubmitText,
    required this.suffixIcon,
    required this.vanishTextOnSubmit,
  }) : super(key: key);

  TextEditingController msgController = TextEditingController();
  final String hint;
  final Function onSubmitText;
  final Icon suffixIcon;
  final bool vanishTextOnSubmit;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Theme.of(context).textTheme.subtitle1,
      cursorColor: Theme.of(context).primaryColor,
      controller: msgController,
      onSubmitted: (value) {
        Log.d(TAG, value);
        if (value != "") {
          onSubmitText(value);
          if (vanishTextOnSubmit) {
            msgController.text = "";
          }
        }
      },
      decoration: InputDecoration(
        labelText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: Theme.of(context).textTheme.subtitle2?.fontSize,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(5),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).primaryColor,
            ),
            child: IconButton(
              onPressed: () {
                String msg = msgController.text;
                if (msg != "") {
                  onSubmitText(msg);
                  if (vanishTextOnSubmit) {
                    msgController.text = "";
                  }
                }
              },
              icon: suffixIcon,
            ),
          ),
        ),
      ),
    );
  }
}
