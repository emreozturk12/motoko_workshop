import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";
import Debug "mo:base/Debug";

actor HomeworkList {

  type Homework = {
    name: Text;
    completed: Bool;
  };

  func natHash(n : Nat) : Hash.Hash { 
    Text.hash(Nat.toText(n))
  };

  var homeworks = Map.HashMap<Nat, Homework>(0, Nat.equal, natHash);
  var nextId : Nat = 0;

  public func getHomeworkById(id : Nat) {
      ignore do ? {
        homeworks.get(id);
      }
  };

  public func addHomework(name : Text) : async Nat {
    let id = nextId;
    homeworks.put(id, { name = name; completed = false });
    nextId += 1;
    Debug.print("New homework added!");
    id
  };

  public func completeHomework(id : Nat) : async () {
    ignore do ? {
      let name = homeworks.get(id)!.name;
      Debug.print("Homework completed!");
      homeworks.put(id, { name; completed = true });
    }
  };

  public query func showAllHomeworks() : async Text {
    var output : Text = "\n- HOMEWORK LIST -";
    for (homework : Homework in homeworks.vals()) {
      output #= "\n" # homework.name;
      if (homework.completed) { output #= " ✔"; };
    };
    output # "\n"
  };

  public func clearCompletedHomeworks() : async () {
    homeworks := Map.mapFilter<Nat, Homework, Homework>(homeworks, Nat.equal, natHash, 
              func(_, homework) { if (homework.completed) null else ?homework });
  };
}