import 'dart:async';
import 'dart:convert';

import 'package:rxdart/rxdart.dart';
import 'package:se_len_den/Models/MemoResponse.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MemoBloc {
  static final MemoBloc _memoBloc = MemoBloc._internal();
  MemoBloc._internal();
  factory MemoBloc() => _memoBloc;

  Socket socket;

  static StreamController<MemoResponse> chatStreamController =
      BehaviorSubject<MemoResponse>();

  static StreamController<JoinMemoResponse> joinStreamController =
      BehaviorSubject<JoinMemoResponse>();

  Function(MemoResponse) get setMemoResponse => chatStreamController.sink.add;

  Stream<MemoResponse> get getMemoResponse => chatStreamController.stream;

  Function(JoinMemoResponse) get setJoinMemoResponse =>
      joinStreamController.sink.add;

  Stream<JoinMemoResponse> get getJoinMemoResponse =>
      joinStreamController.stream;

  void connectAndListen(String accessToken) {
    try {
      socket = io(
          'http://10.0.2.2:5002/memo',
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({"Authorization": "Token $accessToken"})
              .build());
      socket.connect();
      socket.on('join', (data) {
        print(data);
        var res = jsonDecode(data);
        setJoinMemoResponse(JoinMemoResponse.fromJson(res));
      });
      socket.on('chat', (data) {
        print(data);
        var res = jsonDecode(data);
        setMemoResponse(MemoResponse.fromJson(res));
      });
      socket.on('leave', (data) {
        var res = jsonDecode(data);
        setMemoResponse(MemoResponse.fromJson(res));
      });
      socket.onConnect((data) => {print("socket connected")});
      socket.onDisconnect((_) => print('socket disconnected'));
    } catch (e) {
      print(e.toString());
    }
  }

  void joinConvo(String convoId) {
    socket.emit('join', {"conversation_id": convoId});
  }

  void sendMessage(
      {String memoType,
      String msgType,
      String transType,
      dynamic memo,
      String convoId}) {
    socket.emit('chat', {
      "memo_type": memoType,
      "msg_type": msgType,
      "transaction_type": transType,
      "memo": memo,
      "conversation_id": convoId
    });
  }

  void leaveConvo(String convoId) {
    socket.emit('leave', {"conversation_id": convoId});
  }

  void init() {
    if (chatStreamController.isClosed)
      chatStreamController = BehaviorSubject<MemoResponse>();
    if (joinStreamController.isClosed)
      joinStreamController = BehaviorSubject<JoinMemoResponse>();
  }

  void dispose() {
    if (!chatStreamController.isClosed) chatStreamController.close();
    if (!joinStreamController.isClosed) joinStreamController.close();
    socket.disconnect();
  }
}
