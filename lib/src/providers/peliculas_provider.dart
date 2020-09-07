import 'dart:convert';
import 'dart:async';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

///Clase que se encarga de consumir el servicio, donde generamos la url completa a partir de las 3 propiedades que son: _url,_apiKey, languaje
class PeliculasProvider {
  //Api key generado para consumir el servicio de las peliculas
  String _apiKey   = 'da8be7e6b2e9a1088cf7f122e89b15f3';
  //Url de la pagina principal del que estoy consumiendo el api
  String _url      = 'api.themoviedb.org';
  //El lenguaje de para poder tener el resultado en español
  String _language = 'es-ES';
  //El numero de paginas, para obtner los resultados paginados
  int _popularesPage = 0;
  //bandera booleana, falso porque la primera vez que se instancia PeliculasProvaider voy decir que cargando es falso
  bool _cargando = false;
  //Lista de tipo Pelicula que van contener las peliculas populares
  List<Pelicula> _populares = new List();
  //creamos o inicializamos nuestro Stream. Este StreamController va controlar una lista que contine peliculas(creando un Stream de datos).
  //Este seria solo la tuberia del Stream, es decir este seria el Stream Controller
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  ///Este get va ser una Funcion que recibe una lista de Pelicula para que este sea añadido al inicio del stream controller(entrada de información). Esta funcion va requerir una lista de tipo Pelicula.
  ///Este get es para poder insertar informacion el Stream, es decir a la tuberia. usamos .sink que es para agregar
  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  ///este Stream recibe la lista de pelicula para que este sea la salida del stream controller(salida de información).
  ///Este otro get va ser el que reciba la información ingresada, para este usamos .stream
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;
  //Para cerrar el stream controller y ya no pueda recibir mas informacion
  void dispose() {//el nombre dispose es un estandar mas no obligatorio, ya que puedo ponerle cualquier nombre
    _popularesStreamController?.close();//El'?' lo usamos para saber si tiene algun valor, es decir talvez no este inicializado el streamController, entonces al ponerel ? le decimos que si tiene entonces haga el close.
  }


  ///Método que resuleve un Future de lista de tipo Pelicula, el cual se encarga de consumir y procesar toda la respuesta que recibimos de la Api como por ejemplo decodificar la respuesta.
  ///Este método recibe el URI(identificador uniforme de recursos: identifica un recurso por su nombre), esta url sera la direccion del cual estamos consumiendo el servicio.
  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    //Aca recibimos la respuesta de la consulta a la URL que en este caso dicha URL la recibimos en la variable url de tipo Uri
    final respuesta = await http.get( url );//http.get recibe la URL, y hace la peticion a dicha url y esperamos hasta que llegue la respuesta(por eso del await)
    //como ya tenemos la respuesta ahora nos toca decodificar la el cuerpo de la respuesta
    final dataDecodificada = json.decode(respuesta.body);
    // print(dataDecodificada['results']);
    //enviamos a la clase Peliculas la data decodificada pero solo el elemento 'result' en donde esta toda la información que queremos usar y esta clase va devolver una lista de peliculas dependiendo que tipo de peliculas que queramos recibir, por ejemplo: si queremos las peliculas populares pues generamos la url que apunte a ese requerimieto.
    final peliculas = new Peliculas.fromJsonLista(dataDecodificada['results']);
    // print(peliculas.items[0].title);
    //retornamos los items de la clase Peliculas(cada items es una pelicula completa con sus respectivas propiedades)
    return peliculas.items;
  }

  ///Método que resuelve un Future que se encarga retornar o mostrar las peliculas que estan en cine
  Future<List<Pelicula>> getEnCines() async {//es async porque usamos el await para que esper hasta que se resuelva este Future
    //myUrl recibe el nuevo https URI(identificador uniforme de recursos: identifica un recurso por su nombre)
    //esta URI es creado a partir de la autoridad(la url principal), decodificador de ruta(la siguiente parte de url) y un mapa que son las siguiente parte para completar el URI como en este caso la apyKey y el idioma
    final myUrl = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apiKey,
      'language' : _language
    });
    //Le pasamos la url que emos generado para recibir las peliculas que estan en cine
    return await _procesarRespuesta(myUrl);

  }

  ///Método que se encarga de hacer la peticion para mostrar las peliculas populares
  Future<List<Pelicula>> getPopulares() async {
    //si estoy cargando datos voy retornar un arreglo vacio, y si hago una segunda vez va fallar y ya no va ser la peticion
    if(_cargando) return [];//como esta en falso no ve seguir y no va realiazar la peticion
    //cargar datos a true para que cargue solo una vez cuando es necesario
    _cargando = true;
    //incrementar en 1 el numero de pagina cada vez que se llame el metodo getPopulares
    _popularesPage++;

    // print('Cargando siguientes..');
    //Hacemos el llamado a este servicio y nos retorna una respuesta que es  una lista de peliculas
    final urlPopulares = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language': _language,
      'page'    : _popularesPage.toString()//le pasamos el resultado del incremento y lo convertimos a string, la primera vez que se ejecute tendra el valor de 1, ...
    });
    // print(urlPopulares); https://api.themoviedb.org/3/movie/popular?api_key=da8be7e6b2e9a1088cf7f122e89b15f3&language=es-ES
    //Le pasamos la url generada apuntando a las peliculas populares
    final respuesta =  await _procesarRespuesta(urlPopulares);
    //la respuesta le añadimos a la lista de populares que le tengo como una propiedad de esta clase
    _populares.addAll(respuesta);
    //le pasamos la lista de peliculas para que esta pueda añadir la información al streamController
    popularesSink(_populares);
    //cuando ya tengo la respuesta a la peticion http ya no necesito cargar mas datos porque ya esta cargado
    _cargando = false;

    return respuesta;

  }

  ///Método que regresa un Future que a su vez reguresa un lista de Actores. Recibe un argumento de tipo String, este argumento va ser el id de la pelicula, ya que al saber el id de la pelicula se va poder concocer los actores que participaron en dicha pelicula.
  Future<List<Actor>> getCast(String peliId) async {
    //creamos la url que vamos a llamar (endPoint) para consumir el servicio
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key'  : _apiKey,//esta propiedad es requerida
      'language' : _language//el lenguaje es opcional, pero en si seria obligatorio para mi caso porque lo quiero en Español
    });
    //Llamamos la url para consumir dicho servicio y el resultado lo almacenamos en la variable respuesta
    final respuesta = await http.get(url);
    //decodificamos el cuerpo de la respuesta
    final decodeData = jsonDecode(respuesta.body);
    //Instanciamos la clase Cast y llamamos su constructor y a este le enviamos la propiedad cast del la data decodificada
    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;

  }

  ///Método que se encarga hacer la peticion de busqueda, el cual requiere el argumento query que es la consulta o palabra que el usuario esta escribiendo en el cuadro de busqueda.
  Future<List<Pelicula>> buscarPelicula(String query) async {
    //generamos la url a la cual se ara la peticion
    final url = Uri.https(_url, '3/search/movie', {
      'api_key'  : _apiKey,
      'language' : _language,
      'query'    : query
    });

    return await _procesarRespuesta(url);

  }


}