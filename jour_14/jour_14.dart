import "dart:io";
import "dart:math";

enum Terrain{
  roche, sable;
  factory Terrain.fromString{
    switch()
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

class Sol extends Point{
  Terrain terrain;
  Sol(super.x, super.y, this.terrain);

}

class Grille{
  List<List<Point>> terrain = [];
}

void main(){
  String contenu = File("./jour_14/exemple.txt").readAsStringSync();
  RegExp reg = RegExp(r"([0-9]+)(,)([0-9]+)");
  List<int> xListe = [];
  List<int> yListe = [];
  for(var m in reg.allMatches(contenu)){
   xListe.add(int.parse(m.group(1)!));
   yListe.add(int.parse(m.group(3)!));
  }
  int xMin = xListe.reduce(min);
  int yMin = yListe.reduce(min);
  print("xMin: $xMin, yMax: $yMin");

}