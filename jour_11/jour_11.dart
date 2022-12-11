import "dart:io";
import 'dart:math';
import "package:collection/collection.dart";

class Singe{
  static int moduloZinzin = 1;
  List<int> objets = [];
  var _operationInspecte;
  var _operationTest;
  late int _indexSingeTrue;
  late int _indexSingeFalse;

  int compteurInspection = 0;
  late int divisible;

  @override
  String toString() {
    return objets.toString();
  }

  void joueTour(List<Singe> singes){

  print(objets);
    for(int obj in objets){
      //print("  Objet : $obj");
      //print("    inspecte");
      stdout.write("Avant: $obj");

      obj = inspecter(obj);
      stdout.write(", Après : $obj\n");

      //print("    evalue");
      bool resEval = tester(obj);
      //print("    lance");
      if(resEval == true){
        //obj = divisible;
        singes[_indexSingeTrue].objets.add(obj);
      }
      else{
        singes[_indexSingeFalse].objets.add(obj);
      }
    }
    //print("  se debarasse");
    objets.clear();
  }

  Singe.fromStrings(List<String> listeObjets, String operateur, String valeur, String divisible, String singeTrue, String singeFalse, String numPartie){
    objets = listeObjets.map((e) =>  int.parse(e)  ).toList();
    _creerOperationInspecte(operateur, valeur, numPartie);
    _creerOperationTest(divisible);
    _indexSingeTrue = int.parse(singeTrue);
    _indexSingeFalse = int.parse(singeFalse);
    this.divisible = int.parse(divisible);
  }

  int inspecter(int objet){
    compteurInspection ++;

    return _operationInspecte(objet);
  }
  bool tester(int objet){
    //print("test : $objet");
    return _operationTest(objet);
  }
  void _creerOperationInspecte(String operateur, String valeur, String numPartie){

    int? integerValeur = int.tryParse(valeur);
    if(numPartie == "P1"){
      switch(operateur){
        case "+" : switch(integerValeur){
          case null: _operationInspecte = (int x) => ((x + x) / 3).floor(); break;
          default: _operationInspecte = (int x) =>  ((x + integerValeur!) / 3).floor(); break;
        }  break;
        case "*" : switch(integerValeur){
          case null: _operationInspecte = (int x) => ((x * x) / 3).floor(); break;
          default: _operationInspecte = (int x) => ((x * integerValeur!) / 3).floor(); break;
        } break;
      }
    }
    else if(numPartie == "P2"){
      switch(operateur){
        case "+" : switch(integerValeur){
          case null: _operationInspecte = (int x) => (x + x) % moduloZinzin;   break;
          default: _operationInspecte = (int x) => (x + integerValeur!) %moduloZinzin ; break;
        }  break;
        case "*" : switch(integerValeur){
          case null: _operationInspecte = (int x) => (x*x) % moduloZinzin; break;
          default: _operationInspecte = (int x) => (x * integerValeur!) %moduloZinzin ; break;
        } break;
      }
    }
  }
  void _creerOperationTest(String valeur){
    int integerValeur = int.parse(valeur);
    _operationTest = (int x) => x % integerValeur == 0;
  }
}

void main(){
  List<String> lignes = File("./jour_11/input.txt").readAsLinesSync();
  List<Singe> singes = [];

  String numPartie = "P2";

  List<List<String>> strSinges = lignes.slices(7).toList();
  for(List<String> s in strSinges){
    //print("-- Singe --");
    RegExp regNombre = RegExp(r'([0-9]+|old)');
    RegExp regOperateur = RegExp(r'(\+|\*)');
    // Objets
    List<String?> strObjetsTemp = regNombre.allMatches(s[1]).map((z) => z.group(0)).toList();
    List<String> strObjets = strObjetsTemp.where((c) => c != null).cast<String>().toList();
    //print(strObjets);
    // Operation
    String? strOperateurOperation = regOperateur.firstMatch(s[2])![0];
    String? strValeurOperation = regNombre.allMatches(s[2]).map((z) => z.group(0)).last;
    //print("$strOperateurOperation ; $strValeurOperation");
    // Divisible
    String? strValeurDivisible =  regNombre.firstMatch(s[3])![0];
    Singe.moduloZinzin *= int.parse(strValeurDivisible!);
    //print(strValeurDivisible);
    // Lancer
    String? strSingeTrue =  regNombre.firstMatch(s[4])![0];
    String? strSingeFalse =  regNombre.firstMatch(s[5])![0];
    //print("$strSingeTrue ; $strSingeFalse");

    singes.add(Singe.fromStrings(strObjets, strOperateurOperation!, strValeurOperation!, strValeurDivisible!, strSingeTrue!, strSingeFalse!, numPartie));

  }


  List<int> listeInspection  = [];
  int max_1 = 0;
  int max_2 = 0;
  int niveau = 0;


  int nbTours = 0;
  if(numPartie == "P1"){
    nbTours = 20;
  }
  else if(numPartie == "P2"){
    nbTours = 10000;
  }

  for(int t = 0; t < nbTours; t++){
    print("Tour $t");
    for(int i = 0 ; i < singes.length ; i++){
      print("--- Singe $i ---");
      singes[i].joueTour(singes);
    }
  }
  listeInspection  = [];
  for(int i = 0 ; i < singes.length ; i++){
    listeInspection.add(singes[i].compteurInspection);
    print("Singe $i a inspecté des objets ${singes[i].compteurInspection} fois");
  }
  listeInspection.sort((a, b) => b.compareTo(a));
  max_1 = listeInspection[0];
  max_2 = listeInspection[1];
  niveau  = max_1 * max_2;
  print("Niveau au bout de $nbTours tours : $niveau");



}




int pcm(int a, int b) {
  int gcd(int x, int y) {
    if (x == 0) {
      return y;
    }
    return gcd(y % x, x);
  }

  return (a * b) ~/ gcd(a, b);
}

int pcd(int a, int b) {

  if (a == 0) {
    return b;
  }
  return pcd(b % a, a);
}

int pgcd(int a, int b) {
  // Si l'un des nombres est nul, le pgcd est l'autre nombre.
  if (a == 0 || b == 0) {
    return a + b;
  }

  // Appliquons l'algorithme d'Euclide pour trouver le pgcd.
  int reste;
  while (b != 0) {
    reste = a % b;
    a = b;
    b = reste;
  }
  return a;
}