import 'package:flutter/material.dart';

import 'package:peliculas/src/models/pelicula_model.dart';

class MovieHorizontal extends StatelessWidget {
  //Lista que va recibir solo elementos de tipo Pelicula
  final List<Pelicula> peliculas;
  //funcion que va recibir el metodo de getPopulares
  final Function siguientePagina;
  //Cuando es usado esta clase va ser requerido que le pasen una lista de tipo Pelicula
  MovieHorizontal({@required this.peliculas, @required this.siguientePagina});
  //controla las pages que se van mostrar en el punto de vista, en este casolo solo tres paginas o tarjetas y un pequeña parte de la cuarta tarjeta
  final _pageController = new PageController(
    initialPage: 1,//para que empieze con la pagina 1
    viewportFraction: 0.3//cuantas images va mostar: es decir cada imagen va representar 0.3 y si sumamos para llegar a 1 serian 3 entero de imagenes mas una pequeña parte
  );

  @override
  Widget build(BuildContext context) {
    //Para conocer el tamaño de la pantalla del dispositovo en el cual se este usando esta aplicación
    final _screenSize = MediaQuery.of(context).size;
    //este se va ejecutar cada vez que se mueva o se haga scroll horizontal a las tarjetas 
    _pageController.addListener(() {
      //para saber o determinar el final del scroll del pageView y de esa manera cargar mas tarjetas
      if(_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        // print('Carga siguientes peliculas');//cuando llegamos al final del scroll notemos que se imprime este mensaje
        siguientePagina();//cuando llegue al final, entonces lanzamos este metodo
      }
    });

    return Container(
      height: _screenSize.height * 0.25,//el tamaño del contenedor el 22% del tamaño del dispositivo
      //crea una lista que se puede hace scroll y que nos puede servir para cambiar pagina por pagina y scroleando
      child: PageView.builder(//añadiendo el builder le estamos diciendo que solo que vaya renderizando conforme sean necesarias, es decir los va creando bajo demanda, es decir solo cuando sea necesario.
        pageSnapping: false,
        controller: _pageController,
        // children: _tarjetas(context),
        itemCount: peliculas.length,//la cantidad de items que va renderizar
        itemBuilder: (context, index) => _tarjeta(context, peliculas[index]),
      ),
    );
  }


  Widget _tarjeta(BuildContext context, Pelicula peli) {

    //Este va tener el id seguido de la palabra -poster para que sea un id unico y el Hero no se pueda confundir este poster pequeño con el poster pricipal
    peli.uniqueId = '${peli.id}-poster';

    final tarjeta =  Container(
      margin: EdgeInsets.only(right: 13.0),//para que tenga una separacion con la siguiente tarjeta que venga y esta siempre vendra del lado derecho
      child: Column(
        children: <Widget>[
          Hero(//Para realizar animaciones o transacciones de dos imagenes que tengan el mismo tag en ambos lado
            tag: peli.uniqueId,//el tag es un id unico que le va identificar para enlazar al otro que tiene el Hero con el mismo id en su Tag
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(peli.getPosterImg()),//Los poster de cada pelicula
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            peli.title,//añadimos el titulo de cada pelicual
            overflow: TextOverflow.ellipsis,//esto es cuando el texto no cabe y ponemos el overFlow para que ponga los tres puntos(...) para indicar que hay texto pero que no se puede ver porque no cabe
            style: Theme.of(context).textTheme.caption,
          )
        ],
      ),
    );

    return GestureDetector(
      child: tarjeta,
      // onTap: () => print('ID de la pelicula: ${peli.id}')
      //mandamos argumentos a otra pagina mediante el pushNamed
      //el Navigator.pushNamed requiere el contex y el nombre de la ruta, el objeto arguments recibe cualquie objeto y ahi le pasamos la Peli de tipo Pelicula, es decir la Pelicula como tal completa para que pueda ser usado en esa pagina a la cual nos estamo dirigiendo.
      onTap: () => Navigator.pushNamed(context, 'detalle', arguments: peli),
    );

  }

  ///Una lista de Widget donde cada elemento de la lista seran Widgets, y estos Widget tarjetas pequeñas que dentro de ella estaran los posters de las peliculas populares
  List<Widget> _tarjetas(BuildContext context) {
    //Como peliculas es una lista, entoces usamos el metodo map para barrer cada elemento de dicha lista y cada elemento que pase se va ir almacenando en la varible peli.
    return peliculas.map((peli) {
      // print(peli.title);//todos los titulos de las peliculas populares
      //dentro de este contenedor van estar los posters de las pelicuals populares
      return Container(
        margin: EdgeInsets.only(right: 13.0),//para que tenga una separacion con la siguiente tarjeta que venga y esta siempre vendra del lado derecho
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage(
                image: NetworkImage(peli.getPosterImg()),//Los poster de cada pelicula
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 150.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              peli.title,//añadimos el titulo de cada pelicual
              overflow: TextOverflow.ellipsis,//esto es cuando el texto no cabe y ponemos el overFlow para que ponga los tres puntos(...) para indicar que hay texto pero que no se puede ver porque no cabe
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();//convertimos a un lista, ya que el map((peli) va retornar una nueva lista o iterable que puede transformase en un listado de widged que es eso lo que esto haciendo al usar el toList
  }

}