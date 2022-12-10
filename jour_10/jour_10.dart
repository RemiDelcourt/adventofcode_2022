import "dart:io";

class CPU {
  int x = 1;
  int cycle = 1;
  int totalSignal = 0;
  int spritePos = 1;
  bool cycleCurr = true;

  CPU(){
    stdout.write("#");
  }

  void execute(Instruction instruction) {
    dessiner();
    instruction.execute(this);
    cycle++;
    cycleCurr = true;
    calculerSignal();
  }

  void calculerSignal(){
    if (cycle == 20 || (cycle > 20 && (cycle - 20) % 40 == 0)) {
      int signal = x * cycle;
      totalSignal += signal;
      //print("Cycle ${cycle} -> x: ${x}, signal: $signal");
    }
  }

  bool spriteEstVisible(){
    return [x-1, x, x+1].contains(cycle%40);
  }

  void dessiner(){
    if(cycleCurr == true && cycle <240){
      if(cycle % 40 == 0 ){
        stdout.writeln("");
      }
      if(spriteEstVisible()){
        stdout.write("#");
      }
      else{
        stdout.write(".");
      }
      cycleCurr = false;
    }
  }
}

abstract class Instruction {
  void execute(CPU cpu);
}

class NoopInstruction extends Instruction {
  @override
  void execute(CPU cpu) {
    cpu.dessiner();
  }
}

class AddxInstruction extends Instruction {
  final int v;
  AddxInstruction(this.v);

  @override
  void execute(CPU cpu) {
    cpu.cycle ++;
    cpu.cycleCurr= true;
    cpu.calculerSignal();
    cpu.x += v;
    cpu.dessiner();
  }
}


void main(){
  List<String> lignes  = File("./jour_10/input.txt").readAsLinesSync();
  List<Instruction> instructions = [];
  for(String ligne in lignes){
    List<String> decoupe = ligne.split(" ");
    if(decoupe[0] == "addx"){
      instructions.add(AddxInstruction(int.parse(decoupe[1])));
    }
    else if(decoupe[0] == "noop"){
      instructions.add(NoopInstruction());
    }
  }

  CPU cpu = CPU();
  for (Instruction instruction in instructions) {
    cpu.execute(instruction);
  }
  print("\nPartie 1 : Force totale du signal --> ${cpu.totalSignal}");
}