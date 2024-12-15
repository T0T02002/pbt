open QCheck

(* ################################################
   Definitions
   ################################################ *)

let rec take l n =
  if n > 0 then
    match l with
    | [] -> []
    | x :: xs -> x :: take xs (n-1)
  else
    []

let rec drop l n =
  if n > 0 then
    match l with
    | [] -> []
    | _ :: xs -> drop xs (n-1)
  else
    l

(* ################################################
   Start of tests
   ################################################ *)

(**
  Combining [take l n] and [drop l n] gives the starting list
*)
let test_take_drop_append take drop =
  Test.make ~name:"test_take_drop_append"
  (tup2 small_nat (list int)) (fun (n, l) ->

    take l n @ drop l n = l

  )

(**
  Taking then dropping the same amount gives nothing
*)
let test_take_drop_nil take drop =
  Test.make ~name:"test_take_drop_nil"
  (tup2 small_nat (list int)) (fun (n, l) ->

    drop (take l n) n = []

  )

(**
  Taking the same amount twice doesn't change the result
*)
let test_take_take take =
  Test.make ~name:"test_take_take"
  (tup2 small_nat (list int)) (fun (n, l) ->

    take (take l n) n = take l n

  )

let ( -- ) a b = List.init (b - a) (fun x -> a + x)

(**
  [take l n] takes at least [n] elements and at most [List.length l]
*)
let test_take_length take =
  QCheck.Test.make ~name:"test_take_length"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    List.length (take l n) = min (List.length l) n

  )

(**
  [drop l n] drops at most [n] elements
*)
let test_drop_length drop =
  QCheck.Test.make ~name:"test_drop_length"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    List.length (drop l n) = max 0 (List.length l - n)

  )

(**
  [take l n] is a sublist of [l]
*)
let test_take_sublist take =
  QCheck.Test.make ~name:"test_take_sublist"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    let t = take l n in
    List.for_all
      (fun i -> List.mem (List.nth t i) l)
      (0 -- List.length t)

  )

(**
  [drop l n] is a sublist of [l]
*)
let test_drop_sublist drop =
  QCheck.Test.make ~name:"test_drop_sublist"
  (tup2 small_nat (list small_int)) (fun (n, l) ->

    let t = drop l n in
    List.for_all
      (fun i -> List.mem (List.nth t i) l)
      (0 -- List.length t)

  )

;;

(* ################################################
   Test runner
   ################################################ *)

QCheck_runner.run_tests ~verbose:true
  [
    test_take_drop_append take drop;
    test_take_drop_nil take drop;
    test_take_take take;

    test_take_length take;
    test_drop_length drop;

    test_take_sublist take;
    test_drop_sublist drop;
  ];;
