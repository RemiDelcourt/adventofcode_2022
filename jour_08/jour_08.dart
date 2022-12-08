import "dart:io";
import 'dart:math';

const String test = """
30373
25512
65332
33549
35390
""";

List<String> reponse = ["00","01","02","03","04","10","11","12","14","20","21","23","24","30","32","34","40","41","42","43","44"];
void main(){
  List<String> fichier = File("./jour_08/input.txt").readAsLinesSync();
  fichier = test.split("\n")..removeLast();

  List<List<int>> carte = [];
  for(String ligne in fichier){
    carte.add(ligne.split("").map((e) => int.parse(e)).toList());
  }
  int nbLigne = carte.length;
  int nbColonne = carte.first.length;


  List<String> listePos = [];
  for(int ligne = 0; ligne < nbLigne; ligne++){
    // De gauche à droite
    listePos.add("${ligne}0");
    int gaucheMax = carte[ligne][0];
    for(int colonne = 1; colonne < nbColonne ; colonne++){
      if(gaucheMax < carte[ligne][colonne]){
        listePos.add("$ligne$colonne");
      }
      gaucheMax = max(gaucheMax, carte[ligne][colonne]);
    }

    // De droite à gauche
    listePos.add("${ligne}${nbColonne-1}");
    int droiteMax = carte[ligne][nbColonne-1];
    for(int colonne = nbColonne-2; colonne >= 0 ; colonne--){
      if(droiteMax < carte[ligne][colonne]){
        listePos.add("$ligne$colonne");
      }
      droiteMax = max(droiteMax,carte[ligne][colonne]);
    }
  }


  // De haut en bas
  for(int colonne = 0; colonne < nbColonne; colonne++){
    listePos.add("${0}${colonne}");
    int hautMax = carte[0][colonne];
    for(int ligne = 1; ligne < nbLigne ; ligne++){
      if(hautMax < carte[ligne][colonne]){
        listePos.add("$ligne$colonne");
      }
      hautMax = max(hautMax, carte[ligne][colonne]);
    }

  // De bas en Haut
    listePos.add("${carte.length-1}${colonne}");
    int basMax = carte[nbLigne-1][colonne];
    for(int ligne = nbLigne - 2 ; ligne >= 0; ligne--){
      if(basMax < carte[ligne][colonne]){
        listePos.add("$ligne$colonne");
      }
      basMax = max(basMax, carte[ligne][colonne]);
    }
  }

  print(listePos);
  //liste finale : il me manque l'arbre 21 (ligne 2, colonne 1)
  print(listePos.toSet());
  // nb arbres visibles
  print(listePos.toSet().length);

}