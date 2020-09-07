import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

///Va ser el encargado de disparar un método en the moviedb para traerme las películas conforme la persona vaya escribiendo en la caja de busqueda. Este extiende de la clase abstracta SearchDelegate para poder implementar todo lo que consierne a la busqueda.
class DataSearch extends SearchDelegate {
  String seleccion = '';
  //Instanciamos la clase PeliculasProvaidera para poder ocupar sus metodos
  final peliculasProvider = PeliculasProvider();

  //requerido. Estos 4 overrides son requeridos
  @override
  List<Widget> buildActions(BuildContext context) {
    //Las acciones de nuestro AppBar(como el de eliminar o borrar la consulta que esta haciendo)
    return [//debe retornar una lista de Widget
      IconButton(
        icon: Icon(Icons.clear),
        //al hacer click en el icono clear se va lanzar la función query que recibe un String vacio
        onPressed: () {
          query = '';
        },
      )
    ];

  }

  //requerido
  @override
  Widget buildLeading(BuildContext context) {
    //Icono a la izquierda del AppBar(como la flecha para regresar atras o el icono X para limpiar el cuadro de busqueda)
    return IconButton(//debe retornar un Widget
      icon: AnimatedIcon(//icono animado
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        //necesitamos pasarle el contex y el resultado: es el valor proporcionado para el resultado se utiliza como el valor de retorno de la llamada a [showSearch] que inició la búsqueda inicialmente.
        close(context, null);//cierra la pagina de busqueda y retorna a la ruta anterior
      },
    );
  }

  //requerido
  @override
  Widget buildResults(BuildContext context) {
    //Crea los resultados que vamos a mostrar al hacer click en el elemento seleccionado
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.amberAccent,
        child: Text(seleccion),//nombre del elemento seleccionado

      ),
    );
  }
  
  //requerido
  @override
  Widget buildSuggestions(BuildContext context) {
    //Son las sugerencias que aparecen cuando la persona escribe, o mientras va escriebiendo van aparecer los resultados.
    
    //si la consulta esta vacia, es dicir si no ha escrito nada, que retorner un container que seria en si nada o que este en blanco la pagina.
    if(query.isEmpty) {//es para prevenir que no vayamos a construir algo que no existe o barrer elementos que no existen
      return Container();
    }
    //de lo contrario que retorne el FutureBuilder
    return FutureBuilder(
      //el Future que va resolver es el de hacer la consulta a la api y regresar con el resultado que el usuario esta escribiendo en el cuadro de busqueda.
      future: peliculasProvider.buscarPelicula(query),//le pasamos la query que es la cadena de caracteres que el usario escribe en la busqueda
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        //si hay data que retorner un ListView con todo los resultados que exista a esa consulta
        if(snapshot.hasData) {
          //recibimos la lista de peliculas
          final peliculas = snapshot.data;
          return ListView(
            //barremos la lista de peliculas usando un el map
            children: peliculas.map((pelicula) {//e contiene cada elemento o pelicula por separado
              return ListTile(
                leading: FadeInImage(
                  //el icono va ser el poster de la pelicula
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                //para hacer click en los listView
                onTap: () {//a parte de cerrar la ruta voy necesitar navegar a la pagina de detalle
                  close(context, null);//una vez que se haga tap en cualquier ListView ser cierra la pagina de busqueda
                  pelicula.uniqueId = '';//para el  tema de Hero animation
                  //a la pagina al cual se va dirigir una vez que se haga tap es a la pagina de detalle de la pelicula que fue selecciondo
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);//como argumento le pasamo la pelicula que fue selecionado
                },
              );
            }).toList()//lo convertimos a lista, ya que el map retorna un Iterable
          );
        } else{//caso contrario si aun se sigue resolvieldo el Future entonces mostramos hata mientras un loading
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}








// ///Va ser el encargado de disparar un método en the moviedb para traerme las películas conforme la persona vaya escribiendo en la caja de busqueda. Este extiende de la clase abstracta SearchDelegate para poder implementar todo lo que consierne a la busqueda.
// class DataSearch extends SearchDelegate {
//   //string del elemento seleccionado
//   String seleccion = '';
//   //estos seran los resultados dependiendo el nombre que escriba en el cuadro de busqueda
//   final peliculas = [
//     'Spaiderman',
//     'Aquaman',
//     'Capitan América',
//     'Thor',
//     'Hulk',
//     'Ironman',
//   ];
//   //esta lista de pelicula se va mostrar al entrar a la pagina de busqueda
//   final peliculasRecientes = [
//     'Batman',
//     'Avenger'
//   ];

//   //requerido. Estos 4 overrides son requeridos
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     //Las acciones de nuestro AppBar(como el cancelar la busqueda)
//     return [//debe retornar una lista de Widget
//       IconButton(
//         icon: Icon(Icons.clear),
//         //al hacer click en el icono clear se va lanzar la función query que recibe un String vacio
//         onPressed: () {
//           query = '';
//         },
//       )
//     ];

//   }

//   //requerido
//   @override
//   Widget buildLeading(BuildContext context) {
//     //Icono a la izquierda del AppBar(como la flecha para regresar atras o el icono X para limpiar el cuadro de busqueda)
//     return IconButton(//debe retornar un Widget
//       icon: AnimatedIcon(//icono animado
//         icon: AnimatedIcons.menu_arrow,
//         progress: transitionAnimation,
//       ),
//       onPressed: () {
//         //necesitamos pasarle el contex y el resultado: es el valor proporcionado para el resultado se utiliza como el valor de retorno de la llamada a [showSearch] que inició la búsqueda inicialmente.
//         close(context, null);//cierra la pagina de busqueda y retorna a la ruta anterior
//       },
//     );
//   }

//   //requerido
//   @override
//   Widget buildResults(BuildContext context) {
//     //Crea los resultados que vamos a mostrar al hacer click en el elemento seleccionado
//     return Center(
//       child: Container(
//         height: 100.0,
//         width: 100.0,
//         color: Colors.amberAccent,
//         child: Text(seleccion),//nombre del elemento seleccionado

//       ),
//     );
//   }
//   //requerido
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     //Son las sugerencias que aparecen cuando la persona escribe, o mientras va escriebiendo van aparecer los resultados.
//     //Esta es la condicion para que se muestre las sugerencias mientras el usuario vaya escribiendo en el cuadro de busqueda
//     final listaSugerida = (query.isEmpty) //si no hay consulta o esta vacio el cuadro de busqueda
//                           ? peliculasRecientes //que muestre las lista de peliculasRecientes
//                           : peliculas.where(  //caso contrario si hay algo escrito buscamos en la lista de peliculas todos los elementos y dependiendo de la condicion mostramos los resultados
//                             (element) => element.toLowerCase().startsWith(query.toLowerCase())//no importa si empieza con(consulta mayuscula o minuscula)
//                           ).toList();//el where reguesa un iterable por el cual hacemos que regrese un lista
    
//     return ListView.builder(
//       //la cantidad de elementos para sugerir
//       itemCount: listaSugerida.length,
//       //como va ir dibujando los elemntos suguridos
//       itemBuilder: (context, index) {
//         return ListTile(
//           leading: Icon(Icons.movie),
//           title: Text(listaSugerida[index]),
//           onTap: () {
//             seleccion = listaSugerida[index];//nombre del elemento de la lista
//             showResults(context);//al hacer tap en el elemto seleccionado que muestre el resultado
//           },
//         );
//       },
//     );
//   }

// }