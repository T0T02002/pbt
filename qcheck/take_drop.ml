open QCheck

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

let test_take_drop_append =
  Test.make ~name:"test_take_drop_append"
  (tup2 small_nat (list int)) (fun (n, l) ->

    take l n @ drop l n = l

  )

let test_take_drop_nil =
  Test.make ~name:"test_take_drop_nil"
  (tup2 small_nat (list int)) (fun (n, l) ->

    drop (take l n) n = []

  )

let test_take_take =
  Test.make ~name:"test_take_take"
  (tup2 small_nat (list int)) (fun (n, l) ->

    take (take l n) n = take l n

  )

;;

QCheck_runner.run_tests ~verbose:true
  [
    test_take_drop_append;
    test_take_drop_nil;
    test_take_take;
  ]
