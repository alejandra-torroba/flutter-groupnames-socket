
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:groupnames/services/socket_services.dart';

class StatusPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketServices>(context);
    //socketService.socket.emit(event);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Status server:  ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton:FloatingActionButton(
        child: const Icon(Icons.message,),
        elevation: 1,
        onPressed: (){
          //EMITIR
          socketService.socket.emit('emitir-mensaje', {
            'nombre':'Flutter',
            'mensaje':'Hola desde Flutter'
          });
          print('SE MANDA');
        },
      ),
    );
  }

}