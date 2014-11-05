Require Import ExtLib.Core.Type.

Global Instance type_Prop : type Prop :=
{ equal := iff
; proper := fun _ => True
}.

Global Instance typeOk_Prop : typeOk type_Prop.
Proof.
  constructor; compute; firstorder.
Qed.

(** NOTE: These should fit into a larger picture, e.g. lattices or monoids **)
(** And/Conjunction **)
Lemma and_True_iff : forall P, (P /\ True) <-> P.
Proof. intuition. Qed.

Lemma and_and_iff : forall P, (P /\ P) <-> P.
Proof. intuition. Qed.

Lemma and_assoc : forall P Q R, (P /\ Q /\ R) <-> ((P /\ Q) /\ R).
Proof. intuition. Qed.

Lemma and_comm : forall P Q, (P /\ Q) <-> (Q /\ P).
Proof. intuition. Qed.

Lemma and_False_iff : forall P, (P /\ False) <-> False.
Proof. intuition. Qed.

Lemma and_cancel
: forall P Q R : Prop, (P -> (Q <-> R)) -> ((P /\ Q) <-> (P /\ R)).
Proof. intuition. Qed.

Lemma and_iff
: forall P Q R S : Prop,
    (P <-> R) ->
    (P -> (Q <-> S)) ->
    ((P /\ Q) <-> (R /\ S)).
Proof. clear; intuition. Qed.

(** Or/Disjunction **)
Lemma or_False_iff : forall P, (P \/ False) <-> P.
Proof. intuition. Qed.

Lemma or_or_iff : forall P, (P \/ P) <-> P.
Proof. intuition. Qed.

Lemma or_assoc : forall P Q R, (P \/ Q \/ R) <-> ((P \/ Q) \/ R).
Proof. intuition. Qed.

Lemma or_comm : forall P Q, (P \/ Q) <-> (Q \/ P).
Proof. intuition. Qed.

Lemma or_True_iff : forall P, (P \/ True) <-> True.
Proof. intuition. Qed.

(** Implication **)
Lemma impl_True_iff : forall (P : Prop), (True -> P) <-> P.
Proof.
  clear; intros; tauto.
Qed.

Lemma impl_iff
: forall P Q R S : Prop,
    (P <-> R) ->
    (P -> (Q <-> S)) ->
    ((P -> Q) <-> (R -> S)).
Proof. clear. intuition. Qed.


(** Forall **)
Lemma forall_iff : forall T P Q,
                     (forall x,
                        P x <-> Q x) ->
                     ((forall x : T, P x) <-> (forall x : T, Q x)).
Proof.
   intros. setoid_rewrite H. reflexivity.
Qed.

(** Exists **)
Lemma exists_iff : forall T P Q,
                     (forall x,
                        P x <-> Q x) ->
                     ((exists x : T, P x) <-> (exists x : T, Q x)).
Proof.
   intros. setoid_rewrite H. reflexivity.
Qed.