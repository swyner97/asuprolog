% asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize)

% -----------------------------------------------
% MAIN PREDICATE - ENTRY POINT
% -----------------------------------------------

asu(LR, TB, S, FS) :-
    integer(LR), LR > 0,
    integer(TB), TB > 0,
    integer(S),  S  > 0,
    integer(FS), FS > 0,
    !,                                          % cut: prevents falling to error clause on backtrack
    calc_width(LR, S, FS, Width),
    InnerWidth is (3 * 3 * FS) + (2 * S),      % letter area width (3 letters x 3 cols x FS) + 2 gaps
    draw_horizontal_line(Width),
    draw_margin_rows(LR, InnerWidth, TB),
    draw_asu_rows(0, LR, S, FS),
    draw_margin_rows(LR, InnerWidth, TB),
    draw_horizontal_line(Width).

asu(LR, TB, S, FS) :-
    format('Validation Error in asu(~w, ~w, ~w, ~w): all arguments must be positive integers.~n',
           [LR, TB, S, FS]),
    fail.


% -----------------------------------------------
% DIMENSION CALCULATIONS
% -----------------------------------------------

% Total width = borders (2) + left/right margins (2*LR) + letter area + 2 gaps
calc_width(LR, S, FS, Width) :-
    Width is (3 * 3 * FS) + (2 * S) + (2 * LR) + 2.


% -----------------------------------------------
% DRAWING UTILITIES
% -----------------------------------------------

% draw_symbol(+Char, +N): print Char N times
draw_symbol(_, 0) :- !.
draw_symbol(Char, N) :-
    N > 0,
    write(Char),
    N1 is N - 1,
    draw_symbol(Char, N1).

draw_horizontal_line(Width) :-
    draw_symbol('-', Width),
    nl.

draw_margin_row(LR, InnerWidth) :-
    write('|'),
    draw_symbol(' ', LR),
    draw_symbol(' ', InnerWidth),
    draw_symbol(' ', LR),
    write('|'),
    nl.

draw_margin_rows(_, _, 0) :- !.
draw_margin_rows(LR, InnerWidth, TB) :-
    TB > 0,
    draw_margin_row(LR, InnerWidth),
    TB1 is TB - 1,
    draw_margin_rows(LR, InnerWidth, TB1).


% -----------------------------------------------
% STAR PATTERNS (per letter, row/col in 0..4 x 0..2 grid)
% -----------------------------------------------

% Letter A: top row, middle row (left+right cols), bottom row
is_star_A(_, 0).
is_star_A(_, 2).
is_star_A(0, 1).
is_star_A(2, 1).

% Letter U: bottom row, top row (both ends), right column all the way down
is_star_U(_, 0).
is_star_U(_, 2).
is_star_U(4, _).

% Letter S: top, middle, bottom rows fully; left on row 1, right on row 3
is_star_S(0, _).
is_star_S(2, _).
is_star_S(4, _).
is_star_S(1, 0).
is_star_S(3, 2).


% -----------------------------------------------
% UNIFIED LETTER DRAWING PREDICATES
% -----------------------------------------------

% draw one cell: star or space, scaled by FS
draw_cell(IsStarPred, Row, Col, FS) :-
    (call(IsStarPred, Row, Col) ->
        draw_symbol('*', FS)
    ;
        draw_symbol(' ', FS)
    ).

% draw_letter_row(+IsStarPred, +Row, +FS): print one logical row of any 3-col letter
draw_letter_row(IsStarPred, Row, FS) :-
    draw_cell(IsStarPred, Row, 0, FS),
    draw_cell(IsStarPred, Row, 1, FS),
    draw_cell(IsStarPred, Row, 2, FS).

% repeat_letter_row(+IsStarPred, +Row, +FS, +Times): repeat a row FS times for scaling
repeat_letter_row(_, _, _, 0) :- !.
repeat_letter_row(IsStarPred, Row, FS, Times) :-
    Times > 0,
    draw_letter_row(IsStarPred, Row, FS),
    nl,
    Times1 is Times - 1,
    repeat_letter_row(IsStarPred, Row, FS, Times1).

% draw_letter(+IsStarPred, +Row, +FS): iterate all 5 logical rows for any letter
draw_letter(_, 5, _) :- !.
draw_letter(IsStarPred, Row, FS) :-
    Row < 5,
    repeat_letter_row(IsStarPred, Row, FS, FS),
    Row1 is Row + 1,
    draw_letter(IsStarPred, Row1, FS).

% Convenience entry points for each letter (start from row 0)
draw_A(FS) :- draw_letter(is_star_A, 0, FS).
draw_S(FS) :- draw_letter(is_star_S, 0, FS).
draw_U(FS) :- draw_letter(is_star_U, 0, FS).


% -----------------------------------------------
% DRAWING ALL THREE LETTERS SIDE BY SIDE
% -----------------------------------------------

% draw_asu_row: prints one logical row of A, S, U with margins and border
draw_asu_row(Row, LR, S, FS) :-
    write('|'),
    draw_symbol(' ', LR),
    draw_letter_row(is_star_A, Row, FS),
    draw_symbol(' ', S),
    draw_letter_row(is_star_S, Row, FS),
    draw_symbol(' ', S),
    draw_letter_row(is_star_U, Row, FS),
    draw_symbol(' ', LR),
    write('|'),
    nl.

% repeat one logical row FS times (vertical scaling)
repeat_asu_row(_, _, _, _, 0) :- !.
repeat_asu_row(Row, LR, S, FS, Times) :-
    Times > 0,
    draw_asu_row(Row, LR, S, FS),
    Times1 is Times - 1,
    repeat_asu_row(Row, LR, S, FS, Times1).

% iterate through all 5 logical rows
draw_asu_rows(5, _, _, _) :- !.
draw_asu_rows(Row, LR, S, FS) :-
    Row < 5,
    repeat_asu_row(Row, LR, S, FS, FS),
    Row1 is Row + 1,
    draw_asu_rows(Row1, LR, S, FS).