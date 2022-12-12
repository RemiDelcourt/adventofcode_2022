import 'dart:collection';
import "dart:io";

import 'package:collection/collection.dart';
import 'package:graphs/graphs.dart';

class Case {
  late int x, y;
  late int val ;
  Case.init({required this.x, required this.y, this.val = -1});
  Case();
  @override
  String toString() => "$y,$x";
  @override
  bool operator ==(Object other) => other is Case && x == other.x && y == other.y;
}

class Graph {
  final Map<Case, List<Case>> nodes;

  Graph(this.nodes);
}

class Node {
  final String id;
  final int data = 1;

  Node(this.id);

  @override
  bool operator ==(Object other) => other is Node && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '<$id -> $data>';
}



typedef Grille<T> = List<List<T>>;
void main(){
  List<String> lignes = File("./jour_12/exemple.txt").readAsLinesSync();

  print("- Création grille de chaines");
  Grille<String> strGrille = [];
  strGrille.addAll(lignes.map((e) => e.split("")));

  print("- Calcul largeur et hauteur de la grille");
  int largeur = strGrille[0].length;
  int hauteur = strGrille.length;

  print("- Récupération coordonnées de la case de départ et d'arrivée");
  Case coordDepart = trouverCoord(strGrille, largeur, hauteur, "S");
  Case coordArrivee = trouverCoord(strGrille, largeur, hauteur, "E");
  print("   Depart: $coordDepart   --  Arrivee: $coordArrivee");

  print("- Substitution des valeurs des cases départ et arrivée par leurs lettres");
  strGrille[coordDepart.y][coordDepart.x] = "a";
  strGrille[coordArrivee.y][coordArrivee.x] = "z";

  print("- Conversion grille de lettres en grille de Cases");
  Grille<Case> grille = convertirEnGrilleCases(strGrille, largeur, hauteur);
  print(grille);

  print("- Création du graphe");
  Graph graphe = Graph(voisins(grille, hauteur, largeur));
  print(graphe);

  print("- Dijkstra");
  var resDij = dijkstra(graphe, coordDepart.toString(), coordArrivee.toString());
  resDij.forEach((key, value) {
    print("$key: $value");
  });
  print(resDij.keys.length);

  
  shortestPath(coordDepart.toString(), coordArrivee.toString(),graphe)
  
}


Map<String, String> dijkstra(Map<String, List<String>> graph, String startNode, String endNode) {
  // Set of nodes that have been visited
  Set<String> visited = new Set<String>();

  // Set of nodes that are candidates for being visited next
  PriorityQueue<String> candidates = PriorityQueue<String>();

  // Map of nodes to their previous node in the shortest path
  Map<String, String> previousNodes = new Map<String, String>();

  // Start by visiting the start node
  visited.add(startNode);
  candidates.add(startNode);

  while (candidates.isNotEmpty) {
    // Get the node with the shortest path from the start node
    String currentNode = candidates.removeFirst();

    // Check if we have reached the end node
    if (currentNode == endNode) {
      break;
    }

    // Visit all of the current node's neighbors
    for (String neighbor in graph[currentNode]!) {
      if (!visited.contains(neighbor)) {
        visited.add(neighbor);
        candidates.add(neighbor);
        previousNodes[neighbor] = currentNode;
      }
    }
  }

  return previousNodes;
}


Grille<Case> convertirEnGrilleCases (Grille<String> grille, int largeur, int hauteur){
  Grille<Case> caseGrille = List.generate(hauteur, (index) => List.generate(largeur, (index) => Case(), growable: false), growable: false);
  for (int i = 0; i < hauteur; i++) {
    for (int j = 0; j < largeur; j++) {
      caseGrille[i][j].val = (grille[i][j]).codeUnitAt(0);
      caseGrille[i][j].x = j;
      caseGrille[i][j].y = i;
    }
  }
  return caseGrille;
}

Case trouverCoord(Grille<String> grille, int largeur, int hauteur, String element){
  for (int i = 0; i < hauteur; i++) {
    for (int j = 0; j < largeur; j++) {
        if(grille[i][j] == element){
          return Case.init(x:j, y:i);
        }
    }
  }
  throw "Erreur";
}


Map<String, List<String>>  voisins(Grille<Case> grille, int hauteur, int largeur) {

  Map<String, List<String>> graphe = {};
  for (int i = 0; i < hauteur; i++) {
    for (int j = 0; j < largeur; j++) {
      List<String> voisins = [];
      Case caseVoisine;
      Case caseActuelle = grille[i][j];

      // Voisin en haut
      if(i > 0 ){
        caseVoisine = grille[i-1][j];
        if([caseActuelle.val-1, caseActuelle.val, caseActuelle.val+1].contains(caseVoisine.val) ){
          voisins.add(caseVoisine.toString());
        }
      }
      // Voisin en bas
      if(i < hauteur-1){
        caseVoisine = grille[i+1][j];
        if([caseActuelle.val-1, caseActuelle.val, caseActuelle.val+1].contains(caseVoisine.val) ){
          voisins.add(caseVoisine.toString());
        }
      }
      // Voisin à gauche
      if( j > 0 ){
        caseVoisine = grille[i][j-1];
        if([caseActuelle.val-1, caseActuelle.val, caseActuelle.val+1].contains(caseVoisine.val) ){
          voisins.add(caseVoisine.toString());
        }
      }
      // Voisin à droite
      if(j < hauteur-1){
        caseVoisine = grille[i][j+1];
        if([caseActuelle.val-1, caseActuelle.val, caseActuelle.val+1].contains(caseVoisine.val) ){
          voisins.add(caseVoisine.toString());
        }
      }

      graphe[caseActuelle.toString()] = voisins;
    }
  }
  return graphe;
}
