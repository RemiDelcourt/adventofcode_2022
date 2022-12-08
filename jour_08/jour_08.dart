import "dart:io";
import 'package:collection/collection.dart';


void main(){
  List<String> fichier = File("./jour_08/input.txt").readAsLinesSync();

  List<List<int>> carte = [];
  for(String ligne in fichier){
    carte.add(ligne.split("").map((e) => int.parse(e)).toList());
  }

  int nbLigne = carte.length;
  int nbColonne = carte.first.length;


  /* Partie 1 */
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

  print("Partie 1 : Nombre d'arbres visibles --> ${listePos.toSet().length}");


  /* Partie 2 */
  List<int> scoresPano = [];
  for(int i = 0 ; i < nbLigne ; i++){
    for(int j = 0; j < nbColonne ; j++){
      print("[$i][$j]");
      if(i == 0 || j == 0){
        scoresPano.add(0);
      }
      else{
        // Exploration a gauche
        print("gauche");
        int gauche = 0;
        int max = carte[i][j];
        loop_gauche:
        for(int g = j-1; g >= 0 ; g--){
          gauche ++;
          if(carte[i][g] >= max){
            break loop_gauche;
          }
        }

        // Exploration a droite
        print("droite");
        int droite = 0;
        max = carte[i][j];
        loop_droite:
        for(int d = j+1; d < nbColonne ; d++){
          droite ++;
          if(carte[i][d] >= max){
            break loop_droite;
          }
        }

        // Exploration a haut
        print("haut");
        int haut = 0;
        max = carte[i][j];
        loop_haut:
        for(int h = i+1; h < nbLigne ; h++){
          haut ++;
          if(carte[h][j] >= max){
            break loop_haut;
          }
        }

        // Exploration a bas
        print("bas");
        int bas = 0;
        max = carte[i][j];
        loop_bas:
        for(int b = i-1; b >= 0 ; b--){
          bas++;
          if(carte[b][j] >= max){
            break loop_bas;
          }
        }

        scoresPano.add(gauche * droite * haut * bas);
      }
    }
  }
  print("Partie 2 : Score Pano --> ${scoresPano.max}");

}