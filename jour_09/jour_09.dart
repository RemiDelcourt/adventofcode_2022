import "dart:io";

class Corde{
  Set<String> set = {};
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
    return "$x,$y";
  }

  @override
  bool operator ==(Object autre){
    return autre is Point && x == autre.x && y == autre.y;
  }

  void avancer(Direction direction){
    switch(direction){
      case Direction.haut   : y += 1; break;
      case Direction.bas    : y -= 1; break;
      case Direction.gauche : x -= 1; break;
      case Direction.droite : x += 1; break;
    }
  }

  void suivre(Point devant){
    int distanceX = 0;
    int distanceY = 0;
    if(y == devant.y){
      distanceX  = devant.x - x;
      if(distanceX.abs() > 1){
        x += distanceX.sign;
      }
    }
    if(x == devant.x){
      distanceY = devant.y - y;
      if(distanceY.abs() > 1){
        y += distanceY.sign;
      }
    }
    if(this != devant){
      distanceX = devant.x - x;
      distanceY = devant.y - y;
      int sommeDistance = distanceX.abs() + distanceY.abs();
      if([3,4].contains(sommeDistance)){
        x += distanceX.sign;
        y += distanceY.sign;
      }
    }
  }
}

enum Direction{
  haut, bas, gauche, droite;
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

  Corde cordeP1 = Corde(nbSegment: 2);
  traiterCorde(cordeP1, commandes);
  print("Partie 1 : Nombre positions visit??es par la Queue --> ${cordeP1.set.length}");

  Corde cordeP2 = Corde(nbSegment: 10);
  traiterCorde(cordeP2, commandes);
  print("Partie 2 : Nombre positions visit??es par la Queue --> ${cordeP2.set.length}");
}

void traiterCorde(Corde corde, commandes){
  corde.addSet();
  for(int c = 0 ; c < commandes.length ; c++){
    for(int p = 0  ; p < commandes[c].pas ; p++){
      corde.corps.first.avancer(commandes[c].direction);
      for(int s = 1 ; s < corde.corps.length ; s++) {
        corde.corps[s].suivre(corde.corps[s-1]);
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