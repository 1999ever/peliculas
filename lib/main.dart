import 'package:flutter/material.dart';

import 'package:peliculas/src/pages/home_page.dart';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,//Ocultar el debug banner
      title: 'Peliculas',//Titulo de la aplicación
      initialRoute: '/',
      //recibe un mapa con llave de tipo String y valor de tipo Widget función que a su vez esta función recibe el BuildContext.
      routes: {
        '/'     : ( BuildContext contex ) => HomePage(),
      },
    );
  }
}