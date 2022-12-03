import "dart:io";
import "package:collection/collection.dart"; // Paquet officiel

void main(){
  List<String> listeSacs = File("./jour_03/input.txt").readAsLinesSync();
  int sommePriorites = calculerSommePriorites(listeSacs);
  print("Partie 1 : Somme des priorités -> $sommePriorites");

  int nbElfesGroupe = 3;
  int sommePrioritesBadges = calculerSommePrioritesBadges(listeSacs, nbElfesGroupe);
  print("Partie 2 : Somme des priorités de badges -> $sommePrioritesBadges");
}


int calculerSommePrioritesBadges(List<String> listeSacs, int nbElfesGroupe){
  int sommePrioritesBadges = 0;
  List<List<String>> listeGroupesSacs = listeSacs.slices(nbElfesGroupe).toList();
  for(List<String> groupeSacs in listeGroupesSacs){
    List<List<String>> groupeSacsDecoupes = groupeSacs.map((e) => e.split("")).toList();
    String badge = trouverArticleCommun(groupeSacsDecoupes);
    int priorite = calculerPrioriteArticle(badge);
    sommePrioritesBadges += priorite;
  }

  return sommePrioritesBadges;
}


int calculerSommePriorites(List<String> listeSacs){
  int sommePriorites = 0;
  for(String sac in listeSacs){
    List<List<String>> compartiments  = compartimenterSac(sac);
    String articleCommun = trouverArticleCommun(compartiments);
    int priorite = calculerPrioriteArticle(articleCommun);
    sommePriorites += priorite;
  }

  return sommePriorites;
}

List<List<String>> compartimenterSac(String sac){
  List<List<String>> compartiments = [
    sac.substring(0, (sac.length~/2)).split(""),
    sac.substring((sac.length~/2), sac.length).split("")
  ];

  return compartiments;
}

String trouverArticleCommun(List<List<String>> sacsDecoupes){
  List<Set<String>> sets = sacsDecoupes.map((e) => e.toSet()).toList();
  Set<String> commun = sets.first;
  for(int i = 1 ; i < sets.length ; i++){
    commun.retainAll(sets[i]);
  }
  return commun.first;
}

int calculerPrioriteArticle(String article){
  RegExp regexMinuscule = RegExp(r"[a-z]");
  int decalageMinuscule = -96;

  RegExp regexMajuscule = RegExp(r"[A-Z]");
  int decalageMajuscule = -38;

  int priorite = 0;
  if(regexMinuscule.hasMatch(article)){
    priorite = article.codeUnitAt(0) + decalageMinuscule;
  }
  else if(regexMajuscule.hasMatch(article)){
    priorite = article.codeUnitAt(0) + decalageMajuscule;
  }

  return priorite;
}