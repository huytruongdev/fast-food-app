import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? _socket;
  IO.Socket? getSocket() => _socket;

  void initSocket() {
    if (_socket != null && _socket!.connected) return;
    final String baseIO = 'http://10.0.2.2:3000';
    _socket = IO.io(baseIO, IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build());

    _socket?.connect();

    _socket?.onConnect((_) {
      debugPrint('Socket Connected');
    });

    _socket?.onDisconnect((_) => debugPrint('Socket Disconnected'));
  }

  void joinOrderRoom(String orderId) {
    if (_socket != null && _socket!.connected) {
      _socket?.emit('join_order', orderId);
      debugPrint('Joined room: $orderId');
    }
  }

  void onDriverLocationUpdate(Function(dynamic) callback) {
    _socket?.on('delivery_location_update', callback);
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
  
  void off(String event) {
    _socket?.off(event);
  }
}