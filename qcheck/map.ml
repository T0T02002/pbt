(**
  Lists are Functors:
  
  https://wiki.haskell.org/index.php?title=Functor
  https://lean-lang.org/lean4/doc/monads/laws.lean.html#what-are-the-functor-laws
*)

open QCheck

(* ################################################
   Definitions
   ################################################ *)

let rec map (f : 'a -> 'b) (l : 'a list) : 'b list =
  match l with
  | [] -> []
  | x :: xs -> f x :: map f xs

(* ################################################
   Start of tests
   ################################################ *)

(**
  Mapping the identity function over a list preserves the list: [map id l = l]
*)
let test_identity_law map =
  Test.make ~name:"test_identity_law"
  (list small_int) (fun l ->

    map (fun x -> x) l = l

  )

(**
  [map] preserves the composition of functions:
  [map (h . g) x = map h (map g x)]
*)
let test_composition_law map =
  Test.make ~name:"test_composition_law"
  (tup3 (fun1 Observable.int small_int) (fun1 Observable.int small_int) (list small_int)
  )
  (fun (h,g,l) ->
    let h,g = Fn.apply h, Fn.apply g in

    map (Fun.compose h g) l = map h (map g l)

  )

;;

(* ################################################
   Test runner
   ################################################ *)

QCheck_runner.run_tests ~verbose:true
  [
    test_identity_law map;
    test_composition_law map;
  ]
