import 'package:flutter/material.dart';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';


class PeliculaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //recibimos el arguments: peli en la variable pelicula de tipo Pelicula.
    //ModalRoute(una que bloquea interacion con la ruta anterior).of(viene el contex de la pagina).settings(ajusta esta ruta).arguments(recibe el argumento pasado a esta ruta)
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      //Creates a [ScrollView] that creates custom scroll effects using slivers.
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(//es similar al ListView pero que este en lugar del children tiene el delegate
            //Similar al children y este recibe SliverChildListDelegate y que dentro de ella recien van las listas de widget
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0),
                _posteTitulo(pelicula, context),
                _descripcion(pelicula),
                _crearCasting(pelicula)
              ]
            ),
          )
        ],
      ),
    );
  }

  ///Witget que me va crear un AppBar pero usando el SliverAppBar que es mas dinamico que el AppBar normal
  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      //el tamaño de expacion del appBar hacia abajo
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      //Ponemos todo lo que va entrar dentro del AppBar 
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(//al hacer el sliver va mostrar esta imagen
          image: NetworkImage(pelicula.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fadeInDuration: Duration(milliseconds: 1),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  
  ///Este Widget va mostrar un pequeño poster de la pelicula y a lado el Titulo original y el titulo en español. Este necesita recibir la pelicula y el contex
  Widget _posteTitulo(Pelicula pelicula, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueId,
            child: ClipRRect(//para el borde redondeado
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                //mostramos el poster de la pelicula con una altura de 150.0
                image: NetworkImage(pelicula.getPosterImg()),
                //altura del poster
                height: 150.0,
              ),
            ),
          ),
          //para separar el poster del titulo
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subtitle2, overflow: TextOverflow.ellipsis),
                Row(//este row va conterner dos elementos que son el icono y voto promedio de la pelicula
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle2)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  ///Widget que muestra la descripcion de la pelicula, en si es la sipnosis de dicha pelicula. Recibe pelicula de tipo Pelicula.
  Widget _descripcion(Pelicula pelicula) {
    return Container(
      //el padding del container
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        //descripcion de la pelicula
        pelicula.overview,
        //texto justificado
        textAlign: TextAlign.justify,
      ),
    );
  }

  ///Widget que muestra la foto(perfil) y el nombre de los actores que participaron en dicha pelicula, cada perfil ordenado de forma horizontal. Recibe como argumento la Pelicula pelicula porque necesito ocupar el la propiedad id de las peliculas.
  Widget _crearCasting(Pelicula pelicula) {
    //instanciar la clase Peliculas provaider porque necesito ocupar el future getCast
    final peliProvaider = new PeliculasProvider();
    //Creates a widget that builds itself based on the latest snapshot of interaction with a [Future].
    return FutureBuilder(
      //consumimos el future de getCast para crear o mostrar los actore en la parte inferior de la pagina de detalles
      future: peliProvaider.getCast(pelicula.id.toString()),
      //recibe una funcion que esta recibe el context y el snapshot que este contiene una lista
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        //si hay data mostramos el widget _crearActoresPageView, caso contrario no hay data y esto pasa porque aun esta cargando la dato por ende mostramos un CircularProgressIndicator
        if(snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  ///Widget que va crear o mostrar el pelfil poster de la imagen de todos los actores de la pelicula que se elija, todo esta lista va ser creada usando el PageView.builder
  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200.0,//la altura el PageView
      child: PageView.builder(//este es muy usado porque va ir mostrando o renderizando segun se vaya necesitando.
        controller: PageController(//el controlador de como se van mostrar las tarjetas con la foto de pefil de los actores
          viewportFraction: 0.3,//la cantidad de tarjetas que se va ir mostrarndo el punto de vista
          initialPage: 1
        ),
        itemCount: actores.length,
        //recibe el una funcion que esta va retornar la tarjetas de cada actor uno por uno para ser mostrado en el PageView
        itemBuilder: (context, i) => _actorTarjeta(actores[i])//enviamos la lista de actores en su posicion i o indice
      ),
    );
  }

  ///Widget que va crear la tarjeta de como se va mostar cada tajeta de cada actor de la pelicula que se seleccione. Recibe la clase Actor porque necesitamos su metodo y sus propiedades.
  Widget _actorTarjeta( Actor actor ) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(//Para usar el borderRadius
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(//como imagen va tener la foto del actor
              image: NetworkImage(actor.getFoto()),//enviamos el metodo que se encarga de llamar la ruta donde esta almacenada la foto de cada actor.
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,//para la foto solo usamos 150 de altura, el resto sera ocupado por el nombre del actor
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0),//caja que va separar la foto del actor con el nombre dela actor
          Text(
            actor.name,//nombre el actor
            overflow: TextOverflow.ellipsis,
          )
        ],
      ),
    );
  }

}