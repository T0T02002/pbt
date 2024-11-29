open QCheck

let rec insert (l : int list) (x : int) : int list =
  match l with
  | [] -> [ x ]
  | y :: ys -> if x < y then x :: y :: ys else y :: insert ys x

let sort : int list -> int list = List.fold_left insert []


let test_insert_length =
  Test.make ~name:"test_insert_length"
    (tup2 small_int (list int))
    (fun (x, l) ->

      List.length (insert l x) = 1 + List.length l

    )

let test_insert_partition =
Test.make ~name:"test_insert_partition"
    (tup2 small_int (list int))
    (fun (x, l) ->
      let sorted = sort l in
      let lt_x, ge_x = List.partition (fun y -> y < x) sorted in

      insert sorted x = lt_x @ x :: ge_x

    )

let test_insert_sorted =
  Test.make ~name:"test_insert_sorted"
    (tup2 small_int (list int))
    (fun (x, l) ->

      insert (sort l) x = sort (x :: l)

    )
;;

(* Run the tests with `dune utop` *)

QCheck_runner.run_tests ~verbose:true
  [
    test_insert_length;
    test_insert_partition;
    test_insert_sorted
  ]
