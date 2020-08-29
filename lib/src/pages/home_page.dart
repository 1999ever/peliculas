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
    return Scaffold(
      appBar: AppBar(
        title: Text('Películas en cine'),
        backgroundColor: Colors.indigoAccent,
        //Widgets para mostrar en una fila después del widget [título]. Normalmente, estos widgets son [IconButton] que representan operaciones comunes. Para operaciones menos comunes, considere usar un [PopupMenuButton] como última acción. Las [acciones] se convierten en el componente final de la [NavigationToolBar] creada por este widget. La altura de cada acción está restringida a no ser mayor que la altura de la barra de herramientas, que es [kToolbarHeight].
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              
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
            _footer(context)
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


  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subtitle1)
          ),
          SizedBox(height: 5.0),
          FutureBuilder(
            future: peliculasProvider.getPopulares(),
            // initialData: InitialData,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              //el ? lo que va decir es: has ese forEach si existe data, si no hay data no hace el forEach
              // snapshot.data?.forEach((e) => print(e.title));
              if(snapshot.hasData) {
                return MovieHorizontal(peliculas: snapshot.data);
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