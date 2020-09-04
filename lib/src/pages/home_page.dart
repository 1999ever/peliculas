import 'package:flutter/material.dart';

import 'package:peliculas/src/widget/card_swiper_widget.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/widget/movie_horizontal.dart';

///Clase que crea la página de Inicio de la aplicación Películas.
class HomePage extends StatelessWidget {
  ///Propiedad que recibe la instancia de PeliculasProvaider para poder usar sus metodos usando esta varible
  final peliculasProvider = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    //esta instrucion es el que retorna el listado del Future, pero tambien este va ejecutar el .sink.add que el que añade informacion, y abajo en el StreamBuilder ya ejecutamos esa informacion nueva recibida.
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cine'),
        backgroundColor: Colors.indigoAccent,
        //Widgets para mostrar en una fila después del widget [título]. Normalmente, estos widgets son [IconButton] que representan operaciones comunes. Para operaciones menos comunes, considere usar un [PopupMenuButton] como última acción. Las [acciones] se convierten en el componente final de la [NavigationToolBar] creada por este widget. La altura de cada acción está restringida a no ser mayor que la altura de la barra de herramientas, que es [kToolbarHeight].
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // showSearch(context: null, delegate: null);
            },
          )
        ],
      ),
      //cuerpo de la página de inicio
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperTarjetas(),
            _footer(context),//necesitamos mandarle el contex

          ],
        ),
      )
    );
  }

  ///Método que retorna un widget de tarjetas y que estas tarjetas van contener los posters de cada pelicula disponible
  Widget _swiperTarjetas() {
    return FutureBuilder(
      //recibe un Future que contiene la lista de peliculas disponibles en la bd del servicio que estamos consumiendo
      future: peliculasProvider.getEnCines(),
      // initialData: InitialData,
      //recibe el contex y el snapshot(va tener la lista de peliculas que es lo que resuelve el future: pelicu.. el de arriba)
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        // print(snapshot);
        if( snapshot.hasData ) {//hasData quiere decir: si el snapshot tiene data
          return CardSwiperWidget(
            //recibe peliculas porque lo marcamos requerido en su constructor
            peliculas: snapshot.data
          );
        } else {//si no tiene data o miestras se este resolviendo el Future mostramos el indicador circular de progreso
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            )
          );
        }

      },
    );

    // peliculasProvider.getEnCines();
    // //retornamos la tarjeta swiper, es decir nuestro tarjeta perzonalizada
    // return CardSwiperWidget(
    //   //recibe peliculas porque lo marcamos requerido en su constructor
    //   peliculas: [1,2,3,4,5]
    // );
  }

  ///Metodo que retorna un widget que sera para mostrar las peliculas populares que sera scroleable de manera horizontal usando Pageview.
  Widget _footer(BuildContext context) {//necesitamos recibir el contex
    return Container(
      width: double.infinity,//Todo el ancho posible
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,//alinear al inicio del column
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),//un magen del lado izquierdo del texto
            //el Theme.of(cont... me va perimitir configurar de una manera global toda mi aplicación, ejemplo: si queiro que los subtitulos tengan un color en particular simplemente configuro esta linea y ya.
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1)
          ),
          SizedBox(height: 5.0),
          //La diferecia entre es que el StreamBuilder se va ejecutar cada vez que se emita o se ingrese un valor en el Stream, en cambio el FutureBuilder se ejecuta una sola vez.
          StreamBuilder(//esta esperando que ingrese nueva informacion para ejecutarse
            stream: peliculasProvider.popularesStream,//el stream le pasamos el resulatado o la salida del StreamController
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              //el ? lo que va decir es: has ese forEach si existe data, si no hay data no hace el forEach
              // snapshot.data?.forEach((e) => print(e.title));
              if(snapshot.hasData) {
                //enviamos los dos argumentos que la clase requiere
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  //llamamos el metodo que procesa las peliculas populares
                  siguientePagina: peliculasProvider.getPopulares,//este se encarga de ejecutar el metodo para mostrar las peliculas populares cada vez que cumpla la condion de que si esta llegando al fonal del pageView esntonces se ejecute este metodo y pueda cargar mas peliculas.
                );
              } else {
              return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

}