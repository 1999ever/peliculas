import 'package:flutter/material.dart';
//flutter swiper es un paquete externo 
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

///Clase o widget que crea la tarjeta swiper
class CardSwiperWidget extends StatelessWidget {
  ///Propidad que va tener la lista de peliculas, cada elemento de esta lista va ser una pelicula
  final List<Pelicula> peliculas;//lo inicializamos en el constructor
  //Constructor que va recibir la lista de peliculas y este es requerido. Es decir esta clase va recibir la coleccion de elementos que yo necesite mostrar mediante tarjetas swiper.
  CardSwiperWidget({@required this.peliculas});

  @override
  Widget build(BuildContext context) {
    //Propiedad que va tener información sobre el ancho, alto y otras cosas del dispositivo
    final _screenSize = MediaQuery.of(context).size;//El context tiene otra gran cantidad de información pero en este caso voy esar el size que va determinar el tamaño del dispositivo.

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      //recibe new Swiper, es decir la clase encargada para diseñar la tarjeta
      child: Swiper(
        layout: SwiperLayout.STACK,//layout(diseño): El diseño de las tarjetas va ser de tipo stack, es decir se van ordenar uno encima del otro
        itemWidth: _screenSize.width * 0.65,//El ancho del item va ser el 70% del ancho total de la pantalla
        itemHeight: _screenSize.height * 0.5,//El alto va ser el 50% del alto de la pantalla del dispositivo
        //este itemBuilder es similar al future builder que lo que va hacer en este caso es construir y mostrar imagenes
        itemBuilder: (BuildContext context, int indice) {//el indice representa a la pelicula que esta en la primera posicion, luego a la segunda, y asi sucesivamente
          // print(indice);//conoce el indice de cada pelicula en la lista de peliculas
          //creamos el id unico para estos posters de pelicualas el donde dicho id sera la combinacion del mismo id mas la palabra -tarjeta: seria: 12-tarjeta
          peliculas[indice].uniqueId = '${peliculas[indice].id}-tajeta';
        
          return Hero(
            //tag recibe el id unico que se creo
            tag: peliculas[indice].uniqueId,
            child: ClipRRect(//Para hacer los border redondeados de las tarjetas
              borderRadius: BorderRadius.circular(20.0),
              //Las imagenes que seran mostradas en la tarjeta - el boxFit lo que hace es que las images se puedan adaptar a las dimensiones que tiene disponible.
              child: GestureDetector(//para poder ir a otra pagina al hacer tap en esta imagen
                onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peliculas[indice]),//arguments recibe las peliculas en su posicion indice
                child: FadeInImage(
                  //recibe la URL(esta url esta almacenada en el metodo getPosterImg) de todos los poster de cada pelicula
                  image: NetworkImage( peliculas[indice].getPosterImg() ),//peliculas es una lista y el indice tiene las posciones de cada elemento de la lista desde la primera posiciona hasta la ultima
                  //miestra carga los posters de las peliculas mostramos esta imagen local
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                ),
              )
            ),
          );
        },
        //la cantidad de peliculas
        itemCount: peliculas.length,//cantidad de item que va tener este Swiper que va ser la cantidad de elemetos que tiene la lista peliculas
        // pagination: SwiperPagination(), //muestra pequños puntos
        // control: SwiperControl(),  //muestra dos flechas a la izquierda y derecha para poder hacer click y avanzar al siguiente item
      ),
    );
  }
}