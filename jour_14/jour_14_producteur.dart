import "dart:io";
import "dart:math";

void main(){
  String contenu = File("./jour_14/exemple.txt").readAsStringSync();
  RegExp reg = RegExp(r"([0-9]+)(,)([0-9]+)");
  List<int> xListe = [];
  List<int> yListe = [];
  for(var m in reg.allMatches(contenu)){
    xListe.add(int.parse(m.group(1)!));
    yListe.add(int.parse(m.group(3)!));
  }
  int xMin = xListe.reduce(min);
  int yMin = yListe.reduce(min);
  print("xMin: $xMin, yMin: $yMin");

  // Transformation en listes
  contenu = contenu.replaceAll(" -> ", "), Point(");
  print(contenu);
  contenu = contenu.replaceAll('\n',   ")]\n"); //
  print(contenu);

  List<String> strContenu = contenu.split("\n")..removeLast();
  strContenu = strContenu.map((e) => "[Point($e").toList();
  print(strContenu);

  contenu = strContenu.join("\n");
  contenu = "importList<List<Point>> trajectoires = $contenu";

  File("./jour_14/input_alt.dart").writeAsStringSync(contenu);

}