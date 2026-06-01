% asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize)
% Main predicate - entry point
asu(LR, TB, S, FS) :-
    % validation of inputs
    integer(LR), LR >= 0,
    integer(TB), TB >= 0,
    integer(S), S >= 0,
    integer(FS), FS > 0,

    calc_width(LR, S, FS, Width),
    calc_height(TB, FS, _Height),
    draw_horizontal_line(Width),
    % draw_margin_rows(LR, Width - 2*LR, TB),  % TODO: margin not done yet
    draw_asu_rows(0, S, FS),
    % draw_margin_rows(LR, Width - 2*LR, TB),  % TODO: margin not done yet
    draw_horizontal_line(Width),

    % err handling for non ints or negatives
    write('all arguments must be positive integers'), nl, fail.

% -----------------------------------------------
% DIMENSION CALCULATIONS
% -----------------------------------------------

calc_width(LR, S, FS, Width) :-
    Width is (3 * 3 * FS) + (2 * S) + (2 * LR) + 2.

calc_height(TB, FS, Height) :-
    Height is (2 * TB) + (5 * FS).

% -----------------------------------------------
% DRAWING UTILITIES
% -----------------------------------------------

draw_symbol(_, 0).
draw_symbol(Char, N) :-
    N > 0,
    write(Char),
    N1 is N - 1,
    draw_symbol(Char, N1).

draw_horizontal_line(Width) :-
    draw_symbol('-', Width),
    nl.

% draw_margin_row and draw_margin_rows 
% draw_margin_row(LR, InnerWidth) :- ...
% draw_margin_rows(_, _, 0).
% draw_margin_rows(LR, InnerWidth, TB) :- ...

% -----------------------------------------------
% LETTER A LOGIC
% -----------------------------------------------

is_star_A(_, 0).
is_star_A(_, 2).
is_star_A(0, 1).
is_star_A(2, 1).

% -----------------------------------------------
% LETTER U LOGIC
% -----------------------------------------------

is_star_U(_, 0).
is_star_U(_, 2).
is_star_U(4, _).

% -----------------------------------------------
% DRAWING ONE CELL
% -----------------------------------------------

draw_cell(IsStarPred, Row, Col, FS) :-
    (call(IsStarPred, Row, Col) ->
        draw_symbol('*', FS)
    ;
        draw_symbol(' ', FS)
    ).

% -----------------------------------------------
% DRAWING LETTER A
% -----------------------------------------------

draw_A_row(Row, FS) :-
    draw_cell(is_star_A, Row, 0, FS),
    draw_cell(is_star_A, Row, 1, FS),
    draw_cell(is_star_A, Row, 2, FS).

repeat_A_row(_, _, 0).
repeat_A_row(Row, FS, Times) :-
    Times > 0,
    draw_A_row(Row, FS),
    nl,
    Times1 is Times - 1,
    repeat_A_row(Row, FS, Times1).

draw_A(5, _).
draw_A(Row, FS) :-
    Row < 5,
    repeat_A_row(Row, FS, FS),
    Row1 is Row + 1,
    draw_A(Row1, FS).

% -----------------------------------------------
% DRAWING LETTER U
% -----------------------------------------------

draw_U_row(Row, FS) :-
    draw_cell(is_star_U, Row, 0, FS),
    draw_cell(is_star_U, Row, 1, FS),
    draw_cell(is_star_U, Row, 2, FS).

repeat_U_row(_, _, 0).
repeat_U_row(Row, FS, Times) :-
    Times > 0,
    draw_U_row(Row, FS),
    nl,
    Times1 is Times - 1,
    repeat_U_row(Row, FS, Times1).

draw_U(5, _).
draw_U(Row, FS) :-
    Row < 5,
    repeat_U_row(Row, FS, FS),
    Row1 is Row + 1,
    draw_U(Row1, FS).

% -----------------------------------------------
% DRAWING ALL THREE LETTERS ROW BY ROW
% -----------------------------------------------

% draw_asu_row prints one logical row of A, gap, U (S skipped for now)
draw_asu_row(Row, S, FS) :-
    draw_A_row(Row, FS),
    draw_symbol(' ', S),
    % draw_S_row(Row, FS),   % TODO: S not done yet
    draw_symbol(' ', S),
    draw_U_row(Row, FS),
    nl.

% repeat one logical row FS times
repeat_asu_row(_, _, _, 0).
repeat_asu_row(Row, S, FS, Times) :-
    Times > 0,
    draw_asu_row(Row, S, FS),
    Times1 is Times - 1,
    repeat_asu_row(Row, S, FS, Times1).

% iterate through all 5 logical rows
draw_asu_rows(5, _, _).
draw_asu_rows(Row, S, FS) :-
    Row < 5,
    repeat_asu_row(Row, S, FS, FS),
    Row1 is Row + 1,
    draw_asu_rows(Row1, S, FS).