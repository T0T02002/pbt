## Testing `take` and `drop`

* `take l n` collects the first `n` elements of `l` in a new list.

* `drop l n` discards the first `n` elements of `l` and returns the remainder of the list.

Each function does the opposite job of the other, so a first property we could test is:
```ocaml
take l n @ drop l n = l
```
which says that appending the result of taking n elements to the result of dropping n elements should give the list we started with.

If we first take `n` elements from the list and then drop `n` elements from the result, we should end up with the empty list:
```ocaml
drop (take l n) n = []
```

Another interesting fact about `take` is that it's idempotent: once we take n elements from the list, if we keep taking `n` elements we will get the same list:
```ocaml
take (take l n) n = take l n
```

Are `take` and `drop` always bug-free if these three properties hold? Let's say we defined `take` and `drop` like this:

```ocaml
let take _ _ = [] (* The empty list *)

let drop l _ = l  (* The same list *)
```

All three properties hold of these silly definitions! The problem is that they don't check what the functions are doing with the parameter `n`. So, let's add a few more tests targeting the desired behavior.

First, let's check that the length of the list returned by `take` and `drop` actually depends on `n`:

```ocaml
List.length (take l n) = min (List.length l) n
```

```ocaml
List.length (drop l n) = max 0 (List.length l - n)
```

The previous definitions fail these two properties. Great, but do they catch all bugs? Let's define again two silly `take` and `drop`:

```ocaml
let take l n =
  List.init
    (min (List.length l) n)
    (fun _ -> Random.int 10)

let drop l n =
  List.init
    (max 0 (List.length l - n))
    (fun _ -> Random.int 10)
```

These definitions surely generate lists of the right length, but with completely arbitrary elements. Luckily the invariant tests are able to catch this weird behavior by failing, so we're getting close to a complete specification!

It never hurts to add more tests - more tests, more coverage. Let's test that `take` and `drop` preserve the elements of the list.

For both `take` and `drop`, we may state that the lists they produce are sublists of the original list: so, each element that belongs to `take l n` 
also belongs to `l`.

```ocaml
let t = take l n in
List.for_all
  (fun i -> List.mem (List.nth t i) l)
  (0 -- List.length t)
```

Same for `drop l n`:
```ocaml
let t = drop l n in
List.for_all
  (fun i -> List.mem (List.nth t i) l)
  (0 -- List.length t)
```

With these 7 tests in place, we can be pretty sure that our definitions of `take`
and `drop` are correct with respect to our specification.


## Testing `insert`

\#TODO