import 'package:queezy/common/common.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'token_service.dart';

class SocketService {
  late Socket _socket;
  bool _isConnected = false;
  final TokenService _tokenService;
  SocketService(this._tokenService);
  Future<void> initializeSocket() async {
    final token = await _tokenService.getToken();
    _socket = io(
      baseUrl,
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().setAuth({
        'token': token?.token,
      }).build(),
    );
    _socket.on("connection", (_) {
      _isConnected = true;
      print("Connected to webSockets");
    });
    _socket.on("disconnect", (e) {
      _isConnected = false;
      print('Conection failed to webSockets : ${e.toString()}');
    });

    _socket.connect();
  }

  Socket get socket => _socket;

  void on(String event, Function(dynamic) handler) {
    _socket.on(event, handler);
  }

  void emit(String event, dynamic data) {
    // if (_isConnected) {
    _socket.emit(event, data);
    // } else {
    //   print("Cannot emit, socket disconnected");
    // }
  }

  void off(String event) {
    _socket.off(event);
  }
}
