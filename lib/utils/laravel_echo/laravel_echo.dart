// import 'package:laravel_echo/laravel_echo.dart';
// import 'package:pusher_client/pusher_client.dart';

// class LaravelEcho {
//   static LaravelEcho? _singleton;
//   static late Echo _echo;
//   final String token;

//   LaravelEcho._({
//     required this.token,
//   }) {
//     _echo = createLaravelEcho(token);
//   }

//   factory LaravelEcho.init({
//     required String token,
//   }) {
//     if (_singleton == null || token != _singleton?.token) {
//       _singleton = LaravelEcho._(token: token);
//     }

//     return _singleton!;
//   }

//   static Echo get instance => _echo;

//   static String get socketId => _echo.socketId() ?? "11111.11111111";
// }

// class PusherConfig {
//   static const appId = "1894729";
//   static const key = "34c0922713ba825d246c";
//   static const secret = "8045e143cc1fa34ff0ee";
//   static const cluster = "ap1";
//   static const hostEndPoint = "https://133f-60-50-206-230.ngrok-free.app";
//   static const hostAuthEndPoint = "$hostEndPoint/api/broadcasting/auth";
//   static const port = 6001;
// }

// PusherClient createPusherClient(String token) {
//   PusherOptions options = PusherOptions(
//     wsPort: PusherConfig.port,
//     encrypted: true,
//     host: PusherConfig.hostEndPoint,
//     cluster: PusherConfig.cluster,
//     auth: PusherAuth(
//       PusherConfig.hostAuthEndPoint,
//       headers: {
//         'Authorization': "Bearer $token",
//         'Content-Type': "application/json",
//         'Accept': 'application/json'
//       },
//     ),
//   );

//   PusherClient pusherClient = PusherClient(
//     PusherConfig.key,
//     options,
//     autoConnect: false,
//     enableLogging: true,
//   );

//   return pusherClient;
// }

// Echo createLaravelEcho(String token) {
//   return Echo(
//     client: createPusherClient(token),
//     broadcaster: EchoBroadcasterType.Pusher,
//   );
// }