import 'package:flutter/material.dart';

class DataSearch extends SearchDelegate {

  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones de nuestro AppBar(como el cancelar la busqueda)
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del AppBar
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados que vamos a mostrar
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Spn las sugerencias que aparecen cuando la persona escribe
    throw UnimplementedError();
  }

}