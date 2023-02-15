
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:groupnames/models/model_band.dart';
import 'package:groupnames/services/socket_services.dart';


class HomePage extends StatefulWidget{
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Model_Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);       //VE LOS DATOS DEL SERVIDOR Y LOS ACTUALIZA CON CUALQUIER CAMBIO
    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  _handleActiveBands( dynamic payload ){
      bands = (payload as List)
          .map((band) => Model_Band.fromMap(band))
          .toList();

      setState(() {});
  }

  @override
  Widget build(BuildContext context){
    final socketService = Provider.of<SocketServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Band Names', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[700],
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online?
            Icon(Icons.check_circle, color:Colors.greenAccent):
            Icon(Icons.offline_bolt, color:Colors.red),
          )
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, index) => bandTitle(bands[index]),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget bandTitle(Model_Band band) {
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    return Dismissible(
        key: Key(band.id),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) => socketServices.socket.emit('delete-band', {'id':band.id} ),       //LLAMA AL BORRADO EN EL SERVIDOR
        background: Container(
          padding: EdgeInsets.only(left: 20),
          color: Colors.red[700],
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Eliminar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0,2)),
            backgroundColor: Colors.blue[900],
          ),
          title: Text(band.name, style: TextStyle(color: Colors.white),),
          trailing: Text('${band.votes}', style: TextStyle(fontSize: 20, color: Colors.grey),),
          onTap: () => socketServices.socket.emit('vote-band', { 'id':band.id }),
        )
    );
  }

  addNewBand(){
    final textController = TextEditingController();
    
    if(Platform.isAndroid){   //SI EL DISPOSITIVO ES ANDROID
      return showDialog(
          context: context,
          builder: ( _ ) => AlertDialog(
            title: Text('Nombre:'),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                  child: Text('Añadir', style: TextStyle(color: Colors.blue),),
                  elevation: 5,
                  onPressed: () => addBandToList(textController.text)
              )
            ],
          )

      );
    }else{                     // SI EL DISPOSITIVO ES IOS (o no es Android)             
      return showCupertinoDialog(
          context: context, 
          builder: ( _ ) => CupertinoAlertDialog(
            title: Text('Nombre:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Cancelar', style: TextStyle(color: Colors.red),),
                onPressed: () => Navigator.pop(context),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Añadir', style: TextStyle(color: Colors.blue),),
                onPressed: () => addBandToList(textController.text),
              ),
            ],
          )
      );
    }
    
  }
  
  void addBandToList(String name){
    final socketServices = Provider.of<SocketServices>(context, listen: false);
    if(name.length > 1){
      //Agregamos el usuario a la lista
      socketServices.socket.emit('add-band', {'name':name});
    }
    Navigator.pop(context);
  }

  Widget _showGraph(){

    Map<String, double> dataMap = Map();
    bands.forEach((band) {
      dataMap.putIfAbsent( band.name, () => band.votes.toDouble());
    });

    final List<Color> colorList = [
      Colors.blue[400]!,
      Colors.blue[200]!,
      Colors.pink[400]!,
      Colors.pink[200]!,
      Colors.green[400]!,
      Colors.green[200]!,
      Colors.purple[400]!,
      Colors.purple[200]!,
    ];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 240,
      child: PieChart(
        dataMap: dataMap,
        colorList: colorList,
        legendOptions: const LegendOptions(
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      ),
    );
  }
  
}