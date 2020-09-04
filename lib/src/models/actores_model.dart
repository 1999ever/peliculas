///Clase que contiene la lista completa de los actores
class Cast  {
  ///Lista que contiene a los actores
  List<Actor> actores = new List();
  ///Constructor que recibe una lista de elementos dynamic, cada elemento de la lista va contener a los actores de cada pelicula. Y cada elemento de la lista va esta conformado por mapas, es decir una lista de mapas, y cada elemento del mapa va representar a un actor.
  Cast.fromJsonList(List<dynamic> jsonList) {
    //si dicha lista no contiene valores entonces que se quede sin ejecutar
    if(jsonList == null) return;
    //cada elemento de la lista(lista de mapas) lo barremos usando un forEach. Cada elemento(es un mapa) por orden iran pasando por el forEach.
    jsonList.forEach((element) {
      //los elementos(mapas) de la lista se iran pasando al constructor Actor.fromJsonMap y este devolvera un objeto de tipo actor
      final actor = Actor.fromJsonMap(element);
      //cada actor añadimos a la lista que fue inicializa al principio de la clase
      actores.add(actor);
    });

  }

}

///Clase que contiene las propiedades de cada actor de cada pelicula
class Actor {
  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });

  ///Recibimos un Mapa, y cada elemento del mapa respresenta a un actor. Cada elemeto respectivas propiedades, ejemplo: el valor de cast_id sera igual al castId...
  Actor.fromJsonMap(Map<String, dynamic> json) {
    //cada valor del mapa igualamos a sus propiedades
    castId      = json['cast_id'];
    character   = json['character'];
    creditId    = json['credit_id'];
    gender      = json['gender'];
    id          = json['id'];
    name        = json['name'];
    order       = json['order'];
    profilePath = json['profile_path'];

  }

    getFoto() {
    //si la ruta del perfil del actor es nulo
    if( profilePath == null ) {
      //retornamos esta imagen
      return 'https://ramenparados.com/wp-content/uploads/2019/03/no-avatar-png-8.png';
      //caso contrario
    } else {
      //retornamos la ruta del perfil, que en este caso cada Actor tiene su propio perfil y dicha ruta del perfil esta almacenada en la propiedad profilePath
      return 'https://image.tmdb.org/t/p/w500/$profilePath';
    }

  }

}

