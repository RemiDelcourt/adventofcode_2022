import "dart:io";

class Corde{
  Set<String> set = {};
  Point tete = Point(0, 0);
  List<Point> corps = [];

  Corde({required int nbSegment}){
    for(int i = 0 ; i < nbSegment ; i++){
      corps.add(Point(0, 0));
    }
  }

  void addSet(){
    set.add(corps.last.toString());
  }

}

class Point{
  int x;
  int y;
  Point(this.x, this.y);

  @override
  String toString() {
    return "($x,$y)";
  }

  void avancer(Direction direction){
    switch(direction){
      case Direction.haut   : y += 1; break;
      case Direction.bas    : y -= 1; break;
      case Direction.gauche : x -= 1; break;
      case Direction.droite : x += 1; break;
    }
  }

  void suivre(Point tete, int indiceNoeud){
    int distanceX = 0;
    int distanceY = 0;
    if(y == tete.y){
      distanceX  = tete.x - x;
      if(distanceX.abs() > 1){
        x += distanceX.sign;
      }
    }
    if(x == tete.x){
      distanceY = tete.y - y;
      if(distanceY.abs() > 1){
        y += distanceY.sign;
      }
    }
    if(this != tete){
      distanceX = tete.x - x;
      distanceY = tete.y - y;
      int sommeDistance = distanceX.abs() + distanceY.abs();
      if( [3,4].contains(sommeDistance)){
        x += distanceX.sign;
        y += distanceY.sign;
      }
    }
  }
  @override
  bool operator ==(Object autre){
    return autre is Point && x == autre.x && y == autre.y;
  }
}

enum Direction{
  haut,
  bas,
  gauche,
  droite;
  factory Direction.fromString(String strDir){
    switch(strDir){
      case "U" : return Direction.haut;
      case "D" : return Direction.bas;
      case "L" : return Direction.gauche;
      case "R" : return Direction.droite;
    }
    throw "Erreur : $strDir";
  }
}

class Commande{
  late Direction direction;
  late int pas;
  Commande(String strDirection, String strPas){
    direction = Direction.fromString(strDirection);
    pas = int.parse(strPas);
  }
}

void main(){
  List<String> lignesFichier = File("./jour_09/input.txt").readAsLinesSync();
  List<Commande> commandes = analyserLignes(lignesFichier);

  Corde cordeP1 = Corde(nbSegment: 1);
  traiterCorde(cordeP1, commandes);
  print("Partie 1 : Nombre positions visitées par la Queue --> ${cordeP1.set.length}");

  Corde cordeP2 = Corde(nbSegment: 9);
  traiterCorde(cordeP2, commandes);
  print("Partie 2 : Nombre positions visitées par la Queue --> ${cordeP2.set.length}");
}


void traiterCorde(Corde corde, commandes){
  corde.addSet();
  for(int c = 0 ; c < commandes.length ; c++){
    for(int p = 0  ; p < commandes[c].pas ; p++){
      corde.tete.avancer(commandes[c].direction);
      corde.corps.first.suivre(corde.tete, 0);
      corde.addSet();
      for(int s = 1; s < corde.corps.length ;s++) {
        corde.corps[s].suivre(corde.corps[s-1], s);
        corde.addSet();
      }
    }
  }
}

List<Commande> analyserLignes(List<String> lignes){
  List<Commande> commandes  = [];
  for(String ligne in lignes){
    List<String> decoupe = ligne.split(" ");
    commandes.add(Commande(decoupe[0], decoupe[1]));
  }
  return commandes;
}