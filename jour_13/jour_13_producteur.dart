import "dart:io";

class Paire{var p1; var p2; Paire(this.p1, this.p2);}

void main(){
  List<String> lignes = File("./jour_13/input.txt").readAsLinesSync();
  List<String> sortie = [];
  sortie.add("class Paire{var p1; var p2; Paire(this.p1, this.p2);}");
  sortie.add("List<Paire> paires = [");
  for(int i = 0 ; i < lignes.length ; i += 3){
    sortie.add("  Paire(${lignes[i]}, ${lignes[i+1]}),");
  }
  sortie.add("];");

  String stringFinal = sortie.join("\n");

  File("./jour_13/input_alt.dart").writeAsStringSync(stringFinal);
}