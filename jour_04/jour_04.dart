import "dart:io";

typedef Section = int;
typedef Affectation = List<Section>;
typedef Paire = List<Affectation>;

void main(){
  List<String> listeLignes = lireFichier("./jour_04/input.txt");
  List<Paire> listePaire = analyserFichier(listeLignes);

  int sommeRecouvrement = compterRecouvrement(listePaire);
  print("Partie 1 : Nombre de recouvrement --> $sommeRecouvrement");

  int sommeChevauchement = compterChevauchement(listePaire);
  print("Partie 2 : Nombre de chevauchement --> $sommeChevauchement");
}

int compterChevauchement(List<Paire> listePaire){
  int sommeTotale = 0;
  for(Paire paire in listePaire){
    sommeTotale += seChevauche(paire);
  }
  return sommeTotale;
}

int seChevauche(Paire unePaire){
  Affectation aff_1 = unePaire.first;
  Affectation aff_2 = unePaire.last;

  Set<Section> sections_1 = List<int>.generate((aff_1.last-aff_1.first+1), (int index) => (index+aff_1.first)).toSet();
  Set<Section> sections_2 = List<int>.generate((aff_2.last-aff_2.first+1), (int index) => (index+aff_2.first)).toSet();

  Set<Section> valeursChevauche = sections_1.intersection(sections_2);
  int chevauche = valeursChevauche.isNotEmpty ? 1 : 0;
  return chevauche;
}


int compterRecouvrement(List<Paire> listePaire){
  int sommeTotale = 0;
  for(Paire paire in listePaire){
    sommeTotale += seRecouvre(paire);
  }
  return sommeTotale;
}

int seRecouvre(Paire unePaire){
  Affectation aff_1 = unePaire.first;
  Affectation aff_2 = unePaire.last;
  // Cas 1 : 1ères sections identiques
  int contient = 0;
  if(aff_1.first == aff_2.first){
    contient  = 1;
  }
  // Cas 2 : 2èmes sections identiques
  else if(aff_1.last == aff_2.last){
    contient  = 1;
  }
  // Cas 3 : Signes de la soustraction des 1ères et 2èmes sections différents
  else if((aff_1.first - aff_2.first).sign != (aff_1.last - aff_2.last).sign){
    contient = 1;
  }

  return contient;
}


List<Paire> analyserFichier(List<String> listeLignes){
  List<Paire> listePaire = [];
  for(String ligne in listeLignes){
     List<String> decoupePaire = ligne.split(",");
     Paire paire = [];
     for(String affectationBrute in decoupePaire){
       List<String> decoupeAffectation = affectationBrute.split("-");
       Affectation affectation = [];
       for(String sectionBrute in decoupeAffectation){
         affectation.add(int.parse(sectionBrute));
       }
       paire.add(affectation);
     }
     listePaire.add(paire);
  }
  return listePaire;
}

List<String> lireFichier(String chemin) {
  return File(chemin).readAsLinesSync();
}


