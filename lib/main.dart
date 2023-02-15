import 'package:flutter/material.dart';
import 'package:groupnames/services/socket_services.dart';

import 'package:provider/provider.dart';

import 'package:groupnames/pages/home_page.dart';
import 'package:groupnames/pages/server_status.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketServices())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: 'home',
        routes: {
          'home':(_) => HomePage(),
          'status': (_) => StatusPage(),
        },
      ),
    );
  }
}


