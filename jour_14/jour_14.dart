import "dart:io";
import "dart:math";


class Terrain{
  static String roche = "#";
  static String sable = "o";
  static String air = ".";
}


class Grille{
  List<List<String>> cases = [];
  int longueur;
  int hauteur;
  Point<int> grain;
  late Point<int> grainAct;
  int compteurSable = 0;
  Grille(this.longueur, this.hauteur, List<Point<int>> coordRoches, this.grain){
    cases = List.generate(hauteur, (index) => List.generate(longueur, (index) => Terrain.air));
    for(Point<int> roche in coordRoches){
      cases[roche.y][roche.x] = Terrain.roche;
    }
  }

  void remplirSol(){
    for(int x = 0; x < longueur ; x++){
      cases[hauteur-1][x] = Terrain.roche;
    }
  }

  void simulerEcoulement(){
    while(true){
      try {
        unEcoulement();
      }catch(e){
        break;
      }

      if(grain == grainAct ){
        break;
      }
    }

  }

  void unEcoulement(){
    grainAct = Point<int>(grain.x, grain.y);

    while (true) {
      if (cases[grainAct.y + 1][grainAct.x] == Terrain.air) {
        grainAct = Point<int>(grainAct.x, grainAct.y + 1);
      }
      else {
        if (cases[grainAct.y + 1][grainAct.x - 1] == Terrain.air) {
          grainAct = Point<int>(grainAct.x - 1, grainAct.y + 1);
        }
        else if (cases[grainAct.y + 1][grainAct.x + 1] == Terrain.air) {
          grainAct = Point<int>(grainAct.x + 1, grainAct.y + 1);
        }
        else {
          cases[grainAct.y][grainAct.x] = Terrain.sable;
          compteurSable++;
          break;
        }
      }
    }
  }


  @override
  String toString() {
    String aff = " ";
    for(int y = 0; y < hauteur ; y++){
      for(int x = 0; x < longueur ; x++){
        if(y == grain.y && x == grain.x){
          aff += "+ ";
        }
        else{
          aff += "${cases[y][x]}";
        }
      }
      aff += "\n";
    }
    return aff;
  }

}

void main(){
  String contenu = File("./jour_14/input.txt").readAsStringSync();
  Map<String, int> limites = calculerLimites(contenu);

  print("------ Partie 1 ------");
  List<List<Point<int>>> traces = transformerFichier(contenu, limites["xDec"]!, limites["yDec"]!);
  List<Point<int>> tracesInterpol = interpolerTraces(traces);
  Point<int> grain = Point(500-limites["xDec"]!, 0-limites["yDec"]!);
  Grille grille = Grille(limites["longueur"]!, limites["hauteur"]!, tracesInterpol, grain);
  print(grille);

  grille.simulerEcoulement();
  print(grille);
  print("Partie 1 -> Quantité de sable : ${grille.compteurSable}\n");

  // Partie 2
  print("------ Partie 2------");
  List<List<Point<int>>> traces2 = transformerFichier(contenu, 0, 0);
  List<Point<int>> tracesInterpol2 = interpolerTraces(traces2);
  Point<int> grain2 = Point(500, 0);
  Grille grille2 = Grille(limites["xMax"]!+10000, limites["yMax"]!+3, tracesInterpol2, grain2);
  grille2.remplirSol();
  grille2.simulerEcoulement();

  print("Partie 2 -> Quantité de sable : ${grille2.compteurSable}\n");
}



List<Point<int>> interpolerTraces (List<List<Point<int>>> traces){
  List<Point<int>> interpol = [];
  for(List<Point<int>> trace in traces){
    for(int i = 0; i < trace.length-1 ; i++){
      interpol.addAll(calculerPointsIntermediaires(trace[i], trace[i+1]));
    }
  }
  interpol = interpol.toSet().toList();
  return interpol;
}


List<Point<int>> calculerPointsIntermediaires(Point<int> point1, Point<int> point2) {
  int x1 = point1.x;
  int y1 = point1.y;
  int x2 = point2.x;
  int y2 = point2.y;

  // Calculer la distance entre les deux points
  double distance = sqrt(pow((x2 - x1),2) + pow((y2 - y1),2));

  // Calculer le nombre de points intermédiaires à générer
  int nbPoints = distance.round();

  // Calculer les différences entre les coordonnées x et y de chaque point
  double diffX = (x2 - x1) / nbPoints;
  double diffY = (y2 - y1) / nbPoints;

  // Générer les points intermédiaires
  List<Point<int>> points = [];
  for (int i = 0; i < nbPoints; i++) {
    int x = (x1 + (i * diffX)).round();
    int y = (y1 + (i * diffY)).round();
    points.add(Point(x, y));
  }
  points.add(point2);

  return points;
}


List<List<Point<int>>> transformerFichier (String contenu, int xDec, int yDec){
  List<String> lignes = contenu.split("\n")..removeLast();

  List<List<Point<int>>> traces = [];
  for(String ligne in lignes){
    List<String> decoupe = ligne.split(" -> ");
    List<Point<int>> lignePoints = [];
    for(String strCoord in decoupe){
      List<int> coord = strCoord.split(",").map((e) => int.parse(e)).toList();
      Point<int> point = Point<int>(coord[0]-xDec, coord[1]-yDec);
      lignePoints.add(point);
    }
    traces.add(lignePoints);
  }

  return traces;
}

Map<String,int> calculerLimites(String contenu){
  RegExp reg = RegExp(r"([0-9]+)(,)([0-9]+)");
  List<int> xListe = [500];
  List<int> yListe = [0];
  for(var m in reg.allMatches(contenu)){
    xListe.add(int.parse(m.group(1)!));
    yListe.add(int.parse(m.group(3)!));
  }
  int xMin = xListe.reduce(min);
  int yMin = yListe.reduce(min);
  int xMax = xListe.reduce(max);
  int yMax = yListe.reduce(max);
  int longueur = xMax - xMin+1;
  int hauteur = yMax - yMin+1;

  Map<String, int> limites = {
    "longueur": longueur,
    "hauteur" : hauteur,
    "xDec" : xMin,
    "yDec" : yMin,
    "xMax" : xMax,
    "yMax" : yMax,
  };
  return limites;
}