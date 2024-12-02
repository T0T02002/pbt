open QCheck

let rec forall (p : 'a -> bool) (l : 'a list) : bool =
  match l with
  | [] -> true
  | x :: xs -> p x && forall p xs

let test_forall_cons_true =
  Test.make ~name:"test_forall_cons"
  (tup3 small_int (fun1 Observable.int bool) (list small_int))
  (fun (n, p, l) ->
    let p = Fn.apply p in

    p n ==> forall p l ==> forall p (n :: l)

  )

let test_false_in_not_forall =
  Test.make ~name:"test_false_in_not_forall"
  (tup3 small_int (fun1 Observable.int bool) (list small_int))
  (fun (n, p, l) ->
    let p = Fn.apply p in

    not (p n) ==> List.mem n l ==> not (forall p l)

  )

(* A weak test: precondition [forall p l] is rarely true
   QCheck duly warns us
*)

let test_in_forall_true =
  Test.make ~name:"test_in_forall_true"
  (tup3 small_int (fun1 Observable.int bool) (list small_int))
  (fun (n, p, l) ->
    let p = Fn.apply p in

    forall p l ==> List.mem n l ==> p n

  )

(* An example of a bad property... *)

let test_forall_true_in__bad =
  Test.make ~name:"test_forall_true_in__bad"
  (tup3 small_int (fun1 Observable.int bool) (list small_int))
  (fun (n, p, l) ->
    let p = Fn.apply p in

    forall p l ==> p n ==> List.mem n l

  )

(* ...and a bad attempt at fixing it *)

let test_not_forall_not_in =
  Test.make ~name:"test_not_forall_not_in"
  (tup3 small_int (fun1 Observable.int bool) (list small_int))
  (fun (n, p, l) ->
    let p = Fn.apply p in

    not (forall p l) ==> p n ==> not (List.mem n l)

  )

;;

QCheck_runner.run_tests ~verbose:true
  [
    test_forall_cons_true;
    test_false_in_not_forall;
    test_in_forall_true;
    test_forall_true_in__bad;
    test_not_forall_not_in;
  ]
