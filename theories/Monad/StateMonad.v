Require Import Monad.
Require Import Monoid.

Set Implicit Arguments.
Set Strict Implicit.

Section StateType.
  Variable S : Type.

  Record state (t : Type) : Type := mkState
  { runState : S -> t * S }.

  Definition evalState {t} (c : state t) (s : S) : t :=
    fst (runState c s).

  Definition execState {t} (c : state t) (s : S) : S :=
    snd (runState c s).


  Global Instance Monad_state : Monad state :=
  { ret  := fun _ v => mkState (fun s => (v, s))
  ; bind := fun _ c1 _ c2 =>
    mkState (fun s =>
      let (v,s) := runState c1 s in
      runState (c2 v) s)
  }.

  Global Instance State_state : State S state :=
  { get := mkState (fun x => (x,x))
  ; put := fun v => mkState (fun _ => (tt, v))
  }.

  Variable m : Type -> Type.

  Record stateT (t : Type) : Type := mkStateT
  { runStateT : S -> m (t * S)%type }.

  Variable M : Monad m.

  Definition evalStateT {t} (c : stateT t) (s : S) : m t :=
    bind (runStateT c s) (fun x => ret (fst x)).

  Definition execStateT {t} (c : stateT t) (s : S) : m S :=
    bind (runStateT c s) (fun x => ret (snd x)).


  Global Instance Monad_stateT : Monad stateT :=
  { ret := fun _ x => mkStateT (fun s => @ret _ M _ (x,s))
  ; bind := fun _ c1 _ c2 =>
    mkStateT (fun s =>
      @bind _ M _ (runStateT c1 s) _ (fun vs =>
        let (v,s) := vs in
        runStateT (c2 v) s))
  }.

  Global Instance State_stateT : State S stateT :=
  { get := mkStateT (fun x => ret (x,x))
  ; put := fun v => mkStateT (fun _ => ret (tt, v))
  }.

  Global Instance MonadT_stateT : MonadT stateT m :=
  { lift := fun _ c => mkStateT (fun s => bind c (fun t => ret (t, s)))
  }.

  Global Instance Reader_stateT T (MR : Reader T m) : Reader T stateT :=
  { ask := mkStateT (fun s => bind ask (fun t => ret (t, s)))
  ; local := fun f _ c => mkStateT (fun s => local f (runStateT c s))
  }.

  Global Instance Writer_stateT T (Mon : Monoid T) (MR : Writer Mon m) : Writer Mon stateT :=
  { tell := fun x => mkStateT (fun s => bind (tell x) (fun v => ret (v, s)))
  ; listen := fun _ c => mkStateT (fun s => bind (listen (runStateT c s))
    (fun x => let '(a,s,t) := x in
    ret (a,t,s)))
  ; pass := fun _ c => mkStateT (fun s => bind (runStateT c s) (fun x =>
    let '(a,t,s) := x in ret (a, s)))
  }.

End StateType.

Arguments evalState {S} {t} (c) (s).
Arguments execState {S} {t} (c) (s).
Arguments evalStateT {S} {m} {M} {t} (c) (s).
Arguments execStateT {S} {m} {M} {t} (c) (s).