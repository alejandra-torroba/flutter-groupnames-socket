import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart';
enum ServerStatus{
    //Estado del Server (conectado o desconectado)
  Online,
  Offline,
  Connecting

}

class SocketServices with ChangeNotifier{

  //ChangeNotifier ayuda a Provider cuando debe refrescar la interfaz de usuario, redibujar un witget, notificar a los usuarios,...
  //MANEJO DEL STATUS
  late ServerStatus _serverStatus = ServerStatus.Connecting;
  late Socket _socket;

  ServerStatus get serverStatus  => this._serverStatus;
  Socket get socket => this._socket;

  SocketServices(){
    _initConfig();
  }

  void _initConfig(){

    this._socket = io(
        'https://flutter-socket-server.herokuapp.com/',     //'http://localhost:3001'
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build()
    );

    this._socket.onConnect((_){
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_){
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    /*socket.on('nuevo-mensaje', (payload){   //RECIBIR MENSAJE
      print('Recibe un nuevo mensaje:  $payload');
    });*/


  }
}