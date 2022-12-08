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
  //fichier = test.split("\n")..removeLast();

  List<List<int>> carte = [];
  for(String ligne in fichier){
    carte.add(ligne.split("").map((e) => int.parse(e)).toList());
  }

  int nbLigne = carte.length;
  int nbColonne = carte.first.length;


  List<String> listePos = [];
  for(int ligne = 0; ligne < nbLigne; ligne++){
    // De gauche à droite
    listePos.add("L${ligne}C0");
    int gaucheMax = carte[ligne][0];
    for(int colonne = 1; colonne < nbColonne ; colonne++){
      if(gaucheMax < carte[ligne][colonne]){
        listePos.add("L${ligne}C${colonne}");
        gaucheMax = carte[ligne][colonne];
      }
    }

    // De droite à gauche
    listePos.add("L${ligne}C${nbColonne-1}");
    int droiteMax = carte[ligne][nbColonne-1];
    for(int colonne = nbColonne-2; colonne >= 0 ; colonne--){
      if(droiteMax < carte[ligne][colonne]){
        listePos.add("L${ligne}C${colonne}");
        droiteMax = carte[ligne][colonne];
      }
    }
  }



  for(int colonne = 0; colonne < nbColonne; colonne++){
    // De haut en bas
    listePos.add("L${0}C${colonne}");
    int hautMax = carte[0][colonne];
    for(int ligne = 1; ligne < nbLigne ; ligne++){
      if(hautMax < carte[ligne][colonne]){
        listePos.add("L${ligne}C${colonne}");
        hautMax = carte[ligne][colonne];
      }
    }

  // De bas en Haut
    listePos.add("L${nbLigne-1}C${colonne}");
    int basMax = carte[nbLigne-1][colonne];
    for(int ligne = nbLigne - 2 ; ligne >= 0; ligne--){
      if(basMax < carte[ligne][colonne]){
        listePos.add("L${ligne}C${colonne}");
        basMax = carte[ligne][colonne];
      }
    }
  }

  // nb arbres brut
  print(listePos);
  // nb arbres visibles
  print(listePos.toSet());

  print(listePos.toSet().length);

}