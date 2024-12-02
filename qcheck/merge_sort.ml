open QCheck
open Take_drop

let rec merge (l1 : int list) (l2 : int list) : int list =
  match (l1, l2) with
  | [], l | l, [] -> l
  | x :: xs, y :: ys ->
      if x < y then
        x :: merge xs (y :: ys)
      else
        y :: merge (x :: xs) ys

let rec sort l =
  match l with
  | [] -> []
  | [ _ ] -> l
  | l ->
      let n = List.length l / 2 in
      merge (sort (take l n)) (sort (drop l n))

let test_merge_swap =
  Test.make ~name:"test_merge_swap"
  (tup2 (list int) (list int))
  (fun (l1,l2) ->
    let sorted1, sorted2 = sort l1, sort l2 in

    merge sorted1 sorted2 = merge sorted2 sorted1

  )

let test_merge_anywhere =
  Test.make ~name:"test_merge_anywhere"
  (tup3 small_nat small_nat (list int))
  (fun (n,m,l) ->

    merge (sort (take l n)) (sort (drop l n)) =
    merge (sort (take l m)) (sort (drop l m))

  )

let test_merge_silly =
  Test.make ~name:"test_merge_silly"
  (tup2 small_nat (list int))
  (fun (n,l) ->

    merge (sort (take l n)) (sort (drop l n)) =
    merge (take (sort l) n) (drop (sort l) n)

  )

;;

QCheck_runner.run_tests ~verbose:true
  [
    test_merge_swap;
    test_merge_anywhere;
    test_merge_silly;
  ]
