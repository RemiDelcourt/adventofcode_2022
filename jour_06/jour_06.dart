import "dart:io";
import "package:collection/collection.dart";

void main(){
  List<String> signal = File("./jour_06/input.txt").readAsStringSync().split("")..removeLast();

  late int positionMarqueur_1;
  for(int i = 0 ; i < signal.length-3 ; i++ ){
    List<String> morceau = signal.sublist(i, i+4);
    if(morceau.toSet().length == morceau.length){
      positionMarqueur_1 = i+4;
      break;
    }
  }
  print("Partie 1 : Position marqueur --> $positionMarqueur_1");

  late int positionMarqueur_2;
  for(int i = 0 ; i < signal.length-13 ; i++ ){
    List<String> morceau = signal.sublist(i, i+14);
    if(morceau.toSet().length == morceau.length && !morceau.contains("4")){
      positionMarqueur_2 = i+14;
      break;
    }
  }
  print("Partie 2 : Position marqueur --> $positionMarqueur_2");

}
