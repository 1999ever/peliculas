import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';

///Clase que se encarga de consumir el servicio, donde generamos la url completa a partir de las 3 propiedades que son: _url,_apiKey, languaje
class PeliculasProvider {
  //Api key generado para consumir el servicio de las peliculas
  String _apiKey   = 'da8be7e6b2e9a1088cf7f122e89b15f3';
  //Url de la pagina principal del que estoy consumiendo el servicio
  String _url      = 'api.themoviedb.org';
  //El lenguaje de para poder tener el resultado en español
  String _language = 'es-ES';

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {

    //Aca recibimos la respuesta de la consulta a la URL que emos creado arriba que en este caso dicha URL esta almacenado en la variable myUrl
    final respuesta = await http.get( url );//http.get recibe la URL, y hace la peticion a dicha url y esperamos hasta que llegue la respuesta(por eso del await)
    //como ya tenemos la respuesta ahora nos toca decodificar la respuesta en este el cuerpo
    final dataDecodificada = json.decode(respuesta.body);
    // print(dataDecodificada['results']);
    //enviamos a la clase Peliculas los result del json consumido y esta clase va devolver la lista de peliculas disponibles
    final peliculas = new Peliculas.fromJsonLista(dataDecodificada['results']);
    // print(peliculas.items[0].title);
    //retornamos los items de la clase Peliculas(cada items es una pelicula completa con sus respectivas propiedades)
    return peliculas.items;
  }

  //Método que resuelve un Future que se encarga retornar o mostrar las peliculas que estan en cine
  Future<List<Pelicula>> getEnCines() async {//es async porque usamos el await para que esper hasta que se resuelva este Future
    //myUrl recibe el nuevo https URI(identificador uniforme de recursos: identifica un recurso por su nombre)
    //esta URI es creado a partir de la autoridad(la url principal), decodificador de ruta(la siguiente parte de url) y un mapa que son las siguiente parte para completar el URI como en este caso la apyKey y el idioma
    final myUrl = Uri.https(_url, '3/movie/now_playing', {
      'api_key'  : _apiKey,
      'language' : _language
    });

    return await _procesarRespuesta(myUrl);

  }

  Future<List<Pelicula>> getPopulares() async {
    final urlPopulares = Uri.https(_url, '3/movie/popular', {
      'api_key' : _apiKey,
      'language': _language
    });
    // print(urlPopulares); https://api.themoviedb.org/3/movie/popular?api_key=da8be7e6b2e9a1088cf7f122e89b15f3&language=es-ES

        return await _procesarRespuesta(urlPopulares);

  }

}