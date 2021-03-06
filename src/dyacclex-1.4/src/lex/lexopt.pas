{
  Delphi Yacc & Lex
  Copyright (c) 2003,2004 by Michiel Rook
  Based on Turbo Pascal Lex and Yacc Version 4.1

  Copyright (c) 1990-92  Albert Graef <ag@muwiinfa.geschichte.uni-mainz.de>
  Copyright (C) 1996     Berend de Boer <berend@pobox.com>
  Copyright (c) 1998     Michael Van Canneyt <Michael.VanCanneyt@fys.kuleuven.ac.be>
  
  ## $Id: lexopt.pas 1325 2004-08-17 20:07:24Z druid $

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; either version 2 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
}

unit lexopt;

interface



procedure optimizeDFATable;
(* optimize the state table *)

implementation

uses
  lexbase,
  lextable;

(* Partition table used in DFA optimization: *)

(* obsolete

const

max_parts = max_states;*)  (* number of partitions of equivalent states; at
                            worst, each state may be in a partition by
                            itself *)

type

  PartTable = array [0..max_states - 1] of IntSetPtr;
  (* state partitions (DFA optimization) *)

  StatePartTable = array [0..max_states - 1] of integer;
(* partition number of states *)

var

  (* partition table: *)

  n_parts:    integer;
  part_table: ^PartTable;
  state_part: ^StatePartTable;

  (* optimized state and transition table: *)

  n_opt_states:    integer;
  n_opt_trans:     integer;
  opt_state_table: ^StateTable;
  opt_trans_table: ^TransTable;


function equivStates(i, j: integer): boolean;
  (* checks whether states i and j are equivalent; two states are considered
     equivalent iff:
     - they cover the same marker positions (/ and endmarkers of rules)
     - they have transitions on the same symbols/characters, and corresponding
       transitions go to states in the same partition
     two different start states are never considered equivalent *)
var
  ii, jj, k: integer;
  mark_pos_i, mark_pos_j: IntSet;
begin
  (* check for start states: *)
  if (i <= 2 * n_start_states + 1) and (j <= 2 * n_start_states + 1) and
    (i <> j) then
  begin
    Result := False;
    exit;
  end;
  (* check end positions: *)
  empty(mark_pos_i);
  with state_table^[i] do
    for k := 1 to size(state_pos^) do
      if pos_table^[state_pos^[k]].pos_type = mark_pos then
        include(mark_pos_i, state_pos^[k]);
  empty(mark_pos_j);
  with state_table^[j] do
    for k := 1 to size(state_pos^) do
      if pos_table^[state_pos^[k]].pos_type = mark_pos then
        include(mark_pos_j, state_pos^[k]);
  if not equal(mark_pos_i, mark_pos_j) then
  begin
    Result := False;
    exit;
  end;
  (* check transitions: *)
  if n_state_trans(i) <> n_state_trans(j) then
    Result := False
  else  begin
    ii := state_table^[i].trans_lo;
    jj := state_table^[j].trans_lo;
    for k := 0 to pred(n_state_trans(i)) do
      if (trans_table^[ii + k].cc^ <> trans_table^[jj + k].cc^) then
      begin
        Result := False;
        exit;
      end
      else if state_part^[trans_table^[ii + k].next_state] <>
        state_part^[trans_table^[jj + k].next_state] then
      begin
        Result := False;
        exit;
      end;
    Result := True;
  end
end(*equivStates*);

procedure optimizeDFATable;

var
  i, ii, j: integer;
  act_part, new_part, n_new_parts: integer;

begin

  n_parts := 0;

  (* Initially, create one partition containing ALL states: *)

  n_parts := 1;
  part_table^[0] := newIntSet;
  for i := 0 to n_states - 1 do
  begin
    include(part_table^[0]^, i);
    state_part^[i] := 0;
  end;

    (* Now, repeatedly pass over the created partitions, breaking up
       partitions if they contain nonequivalent states, until no more
       partitions have been added during the last pass: *)

  repeat
    n_new_parts := 0;
    act_part    := 0;
    new_part    := n_parts;
    part_table^[new_part] := newIntSet;
    while (n_parts < n_states) and (act_part < n_parts) do
    begin
      for i := 2 to size(part_table^[act_part]^) do
        if not equivStates(part_table^[act_part]^[1],
          part_table^[act_part]^[i]) then
          (* add to new partition: *)
          include(part_table^[new_part]^, part_table^[act_part]^[i]);
      if size(part_table^[new_part]^) <> 0 then
      begin
        (* add new partition: *)
        Inc(n_parts);
        Inc(n_new_parts);
        (* remove new partition from old one: *)
        setminus(part_table^[act_part]^, part_table^[new_part]^);
        (* update partition assignments: *)
        for i := 1 to size(part_table^[new_part]^) do
          state_part^[part_table^[new_part]^[i]] := new_part;
        Inc(new_part);
        part_table^[new_part] := newIntSet;
      end;
      Inc(act_part);
    end;
  until n_new_parts = 0;

  (* build the optimized state table: *)

  n_opt_states := n_parts;
  n_opt_trans  := 0;
  for i := 0 to n_parts - 1 do
  begin
    ii := part_table^[i]^[1];
    opt_state_table^[i] := state_table^[ii];
    with opt_state_table^[i] do
    begin
      trans_lo := n_opt_trans + 1;
      trans_hi := n_opt_trans + 1 + state_table^[ii].trans_hi -
        state_table^[ii].trans_lo;
      for j := 2 to size(part_table^[i]^) do
        setunion(state_pos^, state_table^[
          part_table^[i]^[j]].state_pos^);
    end;
    for j := state_table^[ii].trans_lo to state_table^[ii].trans_hi do
    begin
      Inc(n_opt_trans);
      opt_trans_table^[n_opt_trans] := trans_table^[j];
      with opt_trans_table^[n_opt_trans] do
        next_state := state_part^[next_state];
    end;
  end;

  (* update state table: *)

  n_states     := n_opt_states;
  n_trans      := n_opt_trans;
  state_table^ := opt_state_table^;
  trans_table^ := opt_trans_table^;

end(*optimizeDFATable*);

begin
  new(part_table);
  new(state_part);
  new(opt_state_table);
  new(opt_trans_table);
end(*LexOpt*).
