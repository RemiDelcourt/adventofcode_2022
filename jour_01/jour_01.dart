import "dart:io";
import "dart:math";

void main() {
  // Partie 1
  List<String> lignes = File("./jour_01/input.txt").readAsLinesSync();
  List<int> listeCalories = [];
  int accuCalories = 0;
  for (int i = 0; i < lignes.length; i++) {
    if (lignes[i].isEmpty) {
      listeCalories.add(accuCalories);
      accuCalories = 0;
    }
    else {
      accuCalories += int.parse(lignes[i]);
    }
  }
  int maxCalorie = listeCalories.reduce(max);
  print("Calories transportées par l'elfe en ayant le plus : $maxCalorie");

  // Partie 2
  listeCalories.sort();
  int sommetop3Calories = listeCalories.reversed.toList().sublist(0, 3).reduce((a, b) => a + b);
  print("Calories additionnées du Top 3 : $sommetop3Calories");
}

