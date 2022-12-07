import "dart:io";

// Avec l'assistance de Thomas Aubertin

class Noeud {
  Noeud(this.nom, this.parent);
  String nom;
  Dossier? parent;
}

class Fichier extends Noeud{
  int taille;
  Fichier(super.nom, super.parent, this.taille);
}

class Dossier extends Noeud{
  List<Noeud> enfants = [] ;
  Dossier(super.nom, super.parent);
}

List<int> valGlobale = [];

void main(){
  List<String> aff = File("./jour_07/input.txt").readAsLinesSync();


  Dossier dossierCourant = Dossier(r"/", null);
  List<Bloc> blocs = decoupageBlocs(aff);
  for(int i = 1 ; i < blocs.length ; i++){
    print("${dossierCourant.nom} - ${dossierCourant is Dossier ? "dossier" : "fichier"} ");
    if(blocs[i].commande.first == "ls"){
      for(List<String> resultat in blocs[i].resultats){
        if(resultat.first == "dir"){
          dossierCourant.enfants.add(Dossier(resultat[1], dossierCourant));
        }
        else{
          dossierCourant.enfants.add(Fichier(resultat[1], dossierCourant, int.parse(resultat[0])));
        }
      }
    }
    else if(blocs[i].commande.first == "cd"){
      if(blocs[i].commande[1] == ".."){
        dossierCourant = dossierCourant.parent!;
      }
      else{
        dossierCourant = dossierCourant.enfants.firstWhere((noeud) => noeud is Dossier && noeud.nom == blocs[i].commande[1]) as Dossier;
      }

    }
  }

  dossierCourant = remonterRacine(dossierCourant);
  print("Dossier racine : ${dossierCourant.nom}");

  sommer(dossierCourant);
  print("valGlobale : $valGlobale");

  int somme = 0;
  for(int val in valGlobale){
    if(val <= 100000){
      somme += val;
    }
  }

  print("Partie 1: Somme --> $somme");



  //---------------------------------
  int tailleTotale = 70000000;
  int tailleOccupe  = valGlobale.last;

  int tailleLibre = tailleTotale - tailleOccupe;
  int tailleNecessaire = 30000000 -  tailleLibre;

  valGlobale.sort();
  print(valGlobale);
  for(int val in valGlobale){
    if(val >= tailleNecessaire){
      print("Partie 2: Somme --> $val");
      break;
    }
  }

}

Dossier remonterRacine (Noeud noeud){
    if(noeud.parent == null){
      return noeud as Dossier;
    }
   return remonterRacine(noeud.parent as Dossier);
}

int? sommer (Noeud noeud){
  int valeur = 0;
  if(noeud is Dossier){
    for(Noeud noeudFils in noeud.enfants){
      if(noeudFils is Fichier){
        valeur += noeudFils.taille;
      }
      else if(noeudFils is Dossier){
        valeur += sommer(noeudFils)!;
      }
    }
    valGlobale.add(valeur);
    return valeur;
  }
}


class Bloc {
  List<String> commande = [];
  List<List<String>> resultats = [];
}

List<Bloc> decoupageBlocs(List<String> aff){
  List<Bloc> blocs = [];
  for(int i = 0; i < aff.length ; i ++){
    if (aff[i].startsWith(r"$")){
      blocs.add(Bloc());
      blocs.last.commande = aff[i].split(" ")..removeAt(0);
    }
    else{
      blocs.last.resultats.add(aff[i].split(" "));
    }
  }
  return blocs;
}
