///Clase que va conterner una lista en la cual cada elemento sera una pelicula
class Peliculas {
  ///items es una lista de tipo Pelicula, es decir cada items va representar a una pelicula con sus respecticas propiedades
  List<Pelicula> items = new List();

  Peliculas();
  //Constructor que recibe la lista de todos los resulatados decodificados de la peticion http, es decir todas las peliculas disponibles
  Peliculas.fromJsonLista( List<dynamic> jsonLista ) {
    //si la lista esta vacio, es decir nulo que retorne nada, pero la lista tiene resultados entonces barremos esa lista
    if( jsonLista == null ) return; 
    //Para barrer la lista usamos el ciclo for in y cada elemeto de la lista va ser un item(cada item representa a una pelicula con todo sus respectivos elementos en un mapa)
    for(var item in jsonLista ) {
      //cada item(es una pelicula) le pasamos al contructor de la clase Pelicula para que esta pueda sacar los valores de cada elemento del mapa
      final pelicula = new Pelicula.fromJsonMapa(item);
      //una vez que obtenemos los valores de cada elemento y estos elementos son las propiedades de cada una de las peliculas añadimos a la lista items
      items.add( pelicula );
      // print(pelicula); lista de instancia de todas las peliculas
    }

  }

}

///Clase Pelicula que va manejar las propiedes de cada pelicula
class Pelicula {
  //Propiedades necesarias para consumir el servicio de MovieDB
  double popularity;//popularidad
  int voteCount;//cantidad de votos
  bool video;//video o trailer
  String posterPath;//ruta del poster
  int id;//id
  bool adult;//solo para adultos=true
  String backdropPath;//ruta de imagen de fondo
  String originalLanguage;//idioma original
  String originalTitle;//titulo original
  List<int> genreIds;//genero a la cual pertecene
  String title;//titulo
  double voteAverage;//promedio de votos
  String overview;//vision de conjunto
  String releaseDate;//fecha de lanzamiento
  ///Constructor que recibe 
  Pelicula({
    this.popularity,
    this.voteCount,
    this.video,
    this.posterPath,
    this.id,
    this.adult,
    this.backdropPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.title,
    this.voteAverage,
    this.overview,
    this.releaseDate,
  });
  ///Constructor con nombre que recibe un mapa(cada mapa representa a una pelicula), en el cual esos valores seran asignados a sus respectivas propiedes.
  Pelicula.fromJsonMapa( Map<String, dynamic> myJson ) {
    //donde myJson['popularity'] significa que usando la clave del json obtenemos su valor  y se lo pasamos a la propiedad popularity
    popularity       = myJson['popularity'] / 1;
    voteCount        = myJson['vote_count'];
    video            = myJson['video'];
    posterPath       = myJson['poster_path'];
    id               = myJson['id'];
    adult            = myJson['adult'];
    backdropPath     = myJson['backdrop_path'];
    originalLanguage = myJson['original_language'];
    originalTitle    = myJson['original_title'];
    genreIds         = myJson['genre_ids'].cast<int>();
    title            = myJson['title'];
    voteAverage      = myJson['vote_average'] / 1;
    overview         = myJson['overview'];
    releaseDate      = myJson['release_date'];

  }

  ///Este método obtiene el poster de las peliculas
  getPosterImg() {
    //si el la pelicula no tiene poster
    if( posterPath == null ) {
      //retornamos esta imagen
      return 'https://robertoespinosa.es/wp-content/uploads/2019/10/placeholder.png';
      //caso contrario
    } else {
      //retornamos la ruta del poster, que en este caso cada pelicula tiene su propio poster y dicha ruta esta almacenada en la propiedad posterPath
      return 'https://image.tmdb.org/t/p/w500/$posterPath';
    }

  }

}

