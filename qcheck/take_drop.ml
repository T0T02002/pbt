open QCheck

let rec take l n =
  match l with
  | [] -> []
  | _ when n = 0 -> []
  | l -> take l (n-1)

let rec drop l n =
  match l with
  | [] -> []
  | _ when n = 0 -> l
  | l -> drop l (n-1)

let drop_bad l n = List.rev (take (List.rev l) (List.length l - n))

let test_take_drop_append take drop =
  Test.make ~name:"test_take_drop_append"
  (tup2 small_nat (list int)) (fun (n, l) ->

    take l n @ drop l n = l

  )

let test_take_drop_nil take drop =
  Test.make ~name:"test_take_drop_nil"
  (tup2 small_nat (list int)) (fun (n, l) ->

    drop (take l n) n = []

  )

let test_take_take take =
  Test.make ~name:"test_take_take"
  (tup2 small_nat (list int)) (fun (n, l) ->

    take (take l n) n = take l n

  )

;;

QCheck_runner.run_tests ~verbose:true
  [
    test_take_drop_append take drop;
    test_take_drop_nil take drop;
    test_take_take take;
  ]

(** [take] completely annihilates the list!
    Meanwhile [drop] does absolutely nothing.
    Yet the above invariants hold... let's add more tests:
*)

let ( -- ) a b = List.init (b - a) (fun x -> a + x)

(* Take preserves the first [n] elements of the list *)
let test_take_length take =
  QCheck.Test.make ~name:"test_take_length"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    List.length (take l n) = min (List.length l) n

  )

(* Take preserves the first [n] elements of the list *)
let test_drop_length drop =
  QCheck.Test.make ~name:"test_drop_length"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    List.length (drop l n) = max 0 (List.length l - n)

  )

let test_take_preserves_one take =
  QCheck.Test.make ~name:"test_take_preserves_one"
  (tup3 small_nat small_nat (list small_int)) (fun (i, n, l) ->

    assume (0 <= i && i < min (List.length l) n); (* do NOT use ==> *)
    List.mem (List.nth l i) (take l n)

  )

let test_take_preserves_all take =
  QCheck.Test.make ~name:"test_take_preserves_all"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    assume (l <> []);
    List.for_all
      (fun i -> List.mem (List.nth l i) (take l n))
      (0 -- min (List.length l) n)

  )

;;

QCheck_runner.run_tests ~verbose:true
  [
    test_take_length take;
    test_drop_length drop;
    test_take_preserves_one take;
    test_take_preserves_all take;
  ];;

(** Correct implementation *)

let rec take l n =
  match l with
  | [] -> []
  | _ when n = 0 -> []
  | x :: xs -> x :: take xs (n-1)

let rec drop l n =
  match l with
  | [] -> []
  | _ when n = 0 -> l
  | _ :: xs -> drop xs (n-1)
;;

QCheck_runner.run_tests ~verbose:true
  [
    test_take_drop_append take drop;
    test_take_drop_nil take drop;
    test_take_take take;
    test_take_length take;
    test_drop_length drop;
    test_take_preserves_one take;
    test_take_preserves_all take;
  ];;
