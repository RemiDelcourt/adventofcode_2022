import "dart:io";

class Grille{
  int largeur;
  int hauteur;

  int caseDepart;
  int caseArrivee;

  List<List<Case>> cases = [];
  Grille.fromMatrixString(List<List<String>> strGrille){
    hauteur = strGrille.length;
    largeur = strGrille[0].length;

    for (int y = 0; y < hauteur; y++) {
      for (int x = 0; x < largeur; x++) {
        if (strGrille[y][x] == "S"){
          caseDepart = [y][x];
        }
        if (strGrille[y][x] == "E"){
          caseDepart = [y][x];
        }
      }
    }
  }



}

class Case {
  int x, y;
  int val;
  Case(this.x, this.y, this.val);
  @override
  String toString() => "$x,$y";
  @override
  bool operator ==(Object other) => other is Case && x == other.x && y == other.y;
}

void main(){
  List<String> lignes = File("./jour_12/exemple.txt").readAsLinesSync();
  List<List<String>> strGrille = [];
  strGrille.addAll(lignes.map((e) => e.split("")));

  print(strGrille);
  var v = voisins(strGrille);
  print(v);

}

List<List<int>> voisins(List<List<String>> tableau) {
  int n = tableau.length;
  int m = tableau[0].length;
  List<List<int>> voisins = List.generate(n, (_) => []);

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      voisins[i][j] = [
        i > 0 ? tableau[i-1][j] : null,    // voisin en haut
        i < n-1 ? tableau[i+1][j] : null,  // voisin en bas
        j > 0 ? tableau[i][j-1] : null,    // voisin à gauche
        j < m-1 ? tableau[i][j+1] : null,  // voisin à droite
      ] as int;
    }
  }

  return voisins;
}
