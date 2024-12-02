open QCheck

let rec map (f : 'a -> 'b) (l : 'a list) : 'b list =
  match l with
  | [] -> []
  | x :: xs -> f x :: map f xs

let rec map_bad (f : 'a -> 'b) (l : 'a list) : 'b list =
  match l with
  | [] -> []
  | x :: xs -> f (f x) :: map_bad f xs

(*
  1. map id x = x
  2. map (h . g) x = map h (map g x)
*)

let test_identity_law map_impl =
  Test.make ~name:"test_identity_law"
  (list small_int) (fun l ->

    map_impl Fun.id l = l

  )

let test_composition_law map_impl =
  Test.make ~name:"test_composition_law"
  (tup3 (fun1 Observable.int small_int) (fun1 Observable.int small_int) (list small_int)
  )
  (fun (h,g,l) ->
    let h,g = Fn.apply h, Fn.apply g in

    map_impl (Fun.compose h g) l = map_impl h (map_impl g l)

  )

;;

QCheck_runner.run_tests ~verbose:true
  [
    test_identity_law map;
    test_composition_law map;

    test_identity_law map_bad;
    test_composition_law map_bad;
  ]
