import "dart:io";
import "dart:collection";
import "dart:math";

typedef Caisse = String;
typedef Pile = ListQueue<Caisse>;
typedef Cargo = List<Pile>;

void main(){
  String fichierBrut = File("./jour_05/input.txt").readAsStringSync();
  List<String> fichierDecoupe = fichierBrut.split("\n\n");

  List<String> cargoLignes = fichierDecoupe.first.split("\n");
  List<String> procedureBrut = fichierDecoupe.last.split("\n")..removeLast();

  int nbPiles = (cargoLignes.first.length / 4).ceil();

  Cargo cargo = [];

  for(int i = 0; i < nbPiles; i++ ){
    Pile pile = Pile();
    break_pile:
    for(int j = cargoLignes.length-2; j >= 0  ; j--){
      Caisse caisse = cargoLignes[j][i*4+1];
      if(caisse == " "){
        break break_pile;
      }
      pile.addFirst(caisse);
    }
    cargo.add(pile);
  }

  String mode = "CrateMover9001";
  print(cargo);
  deplacerCaisse(cargo, procedureBrut, mode);
  print(cargo);
  String caissesDessus = creerChaineCaisses(cargo);
  print("$mode : Chaine caisses du dessus --> $caissesDessus");
}

String creerChaineCaisses(Cargo cargo){
  String chaine  = "";
  for(Pile pile in cargo){
    chaine += pile.first;
  }
  return chaine;
}

void deplacerCaisse(Cargo cargo, List<String> procedureBrut, String mode){
  for(String uneProc in procedureBrut){
    RegExp reg = RegExp(r'[0-9]+');
    var x = reg.allMatches(uneProc).map((z) => z.group(0)).toList();

    int nbBouge = int.parse(x[0]!);
    int numPileDepart = int.parse(x[1]!)-1;
    int numPileArrivee = int.parse(x[2]!)-1;

    if(mode == "CrateMover9000") {
      for (int i = 0; i < nbBouge; i++) {
        Caisse caisse = cargo[numPileDepart].first;
        cargo[numPileDepart].removeFirst();
        cargo[numPileArrivee].addFirst(caisse);
      }
    }
    else if(mode == "CrateMover9001"){
      List<Caisse> tasProvisoire = [] ;
      for (int i = 0; i < nbBouge; i++) {
        Caisse caisse = cargo[numPileDepart].first;
        cargo[numPileDepart].removeFirst();
        tasProvisoire.add(caisse);
      }
      tasProvisoire = tasProvisoire.reversed.toList();
      for( int i = 0 ; i < tasProvisoire.length ; i++){
        cargo[numPileArrivee].addFirst(tasProvisoire[i]);
      }
    }
  }
}