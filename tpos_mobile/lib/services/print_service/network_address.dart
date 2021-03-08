import 'dart:async';
import 'dart:io';

class NetworkAddress {
  NetworkAddress(this.ip, this.exists);
  bool exists;
  String ip;
}

class NetworkAnalyzer {
  static Future<Socket> _ping(String host, int port, Duration timeout) {
    return Socket.connect(host, port, timeout: timeout).then((socket) {
      return socket;
    });
  }

  static Stream<NetworkAddress> discover(
    String subnet,
    int port, {
    Duration timeout = const Duration(seconds: 5),
  }) {
    if (port < 1 || port > 65535) {
      throw 'Incorrect port';
    }

    final out = StreamController<NetworkAddress>();
    final futures = <Future<Socket>>[];

    for (int i = 1; i < 256; ++i) {
      final host = '$subnet.$i';
      final Future<Socket> f = _ping(host, port, timeout);
      futures.add(f);

      f.then((socket) {
        socket.destroy();
        socket.close();
        out.sink.add(NetworkAddress(host, true));
      }).catchError((dynamic e) {
        if (!(e is SocketException)) {
          throw e;
        }
        // 13: Connection failed (OS Error: Permission denied)
        // 49: Bind failed (OS Error: Can't assign requested address)
        // 61: OS Error: Connection refused
        // 64: Connection failed (OS Error: Host is down)
        // 65: No route to host
        // 101: Network is unreachable
        // 111: Connection refused
        // 113: No route to host
        // <empty>: SocketException: Connection timed out
        final errorCodes = [13, 49, 61, 64, 65, 101, 111, 113];

        // Check if connection timed out or one of the predefined errors
        if (e.osError == null || errorCodes.contains(e.osError.errorCode)) {
          out.sink.add(NetworkAddress(host, false));
        } else {
          // 23,24: Too many open files in system
          throw e;
        }
      });
    }

    Future.wait<Socket>(futures)
        .then<void>((sockets) => out.close())
        .catchError((dynamic e) => out.close());

    return out.stream;
  }
}
