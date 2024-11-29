let rec insert (l : int list) (x : int) : int list =
  match l with
  | [] -> [ x ]
  | y :: ys -> if x < y then x :: y :: ys else y :: insert ys x

let sort : int list -> int list = List.fold_left insert []

let test_insert_length =
  QCheck.(
    Test.make
      (tup2 small_int (list int))
      (fun (x, l) -> List.length (insert l x) = 1 + List.length l))

let test_insert_partition =
  QCheck.(
    Test.make
      (tup2 small_int (list int))
      (fun (x, l) ->
        let l' = sort l in
        let smaller, bigger = List.partition (fun y -> y < x) l' in
        insert l' x = smaller @ (x :: bigger)))

let test_insert_sorted =
  QCheck.(
    Test.make
      (tup2 small_int (list int))
      (fun (x, l) -> insert (sort l) x = sort (x :: l)))
;;

QCheck_runner.run_tests ~verbose:true
  [ test_insert_length; test_insert_partition; test_insert_sorted ]
