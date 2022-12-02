import "dart:io";

const List<int> gammeResultats = [3, 6, 0];
const Map<String, List<int>> val = {
  "A" : [1],
  "B" : [2],
  "C" : [3],
  "X" : [1,4],
  "Y" : [2],
  "Z" : [3,0],

};

const Map<String, int> fataliseur = {
  "X" : 0,
  "Y" : 3,
  "Z" : 6
};

const Map<String, int> correcteur = {
  "X" : -1,
  "Y" : 0,
  "Z" : 1
};

void main(){
    List<String> listeTours = File("./jour_02/input.txt").readAsLinesSync();
    int scoreTotal_p1 = 0;
    int scoreTotal_p2 = 0;
    for(String tour in listeTours){
        List<String> combat = tour.split(" ");
        // Partie 1
        int scoreForme = val[combat.last]!.first;
        int scoreResultat = gammeResultats[(val[combat.last]!.first - val[combat.first]!.first) % 3];
        int scoreCombat =  scoreForme + scoreResultat;
        scoreTotal_p1 += scoreCombat;

        // Partie 2
        int valBrute = (val[combat.first]!.first + correcteur[combat.last]!);
        String attaque = val.entries.lastWhere((element) => element.value.contains(valBrute)).key;
        int scoreCombat2 = fataliseur[combat.last]! + val[attaque]!.first;
        scoreTotal_p2 += scoreCombat2;

        print("$combat : P1: $scoreForme + $scoreResultat = $scoreCombat | P2: $scoreCombat2");

    }
    print("Partie 1 -> Score total : $scoreTotal_p1");
    print("Partie 2 -> Score total : $scoreTotal_p2");
}