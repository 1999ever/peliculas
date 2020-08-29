import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';



class MovieHorizontal extends StatelessWidget {

  final List<Pelicula> peliculas;

  MovieHorizontal({@required this.peliculas});

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      height: _screenSize.height * 0.22,
      child: PageView(//crea una lista que se puede hace scroll y que nos puede servir para cambiar pagina por pagina y scroleando
        pageSnapping: false,
        controller: PageController(
          initialPage: 1,//para que empieze con la pagina 1
          viewportFraction: 0.3//cuantas images va mostar: es decir cada imagen va representar 0.3 y si sumamos para llegar a 1 serian 3 entero de imagenes mas una pequeña parte
        ),
        children: _tarjetas(),
      ),
    );
  }


  List<Widget> _tarjetas() {
    return peliculas.map((peli) {
      return Container(
        margin: EdgeInsets.only(right: 13.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(peli.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            )
          ],
        ),
      );
    }).toList();
  }

}