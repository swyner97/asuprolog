% asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize)

:- multifile check:checker/2. 
check:checker(my_checks:asu_format_mistakes, "errors with asu/4 arguments").

% Main predicate - entry point
asu(LR, TB, S, FS) :-
    % Validate inputs
    integer(LR), LR > 0,
    integer(TB), TB > 0,
    integer(S), S > 0,
    integer(FS), FS > 0,

    calc_width(LR, S, FS, Width),
    calc_height(TB, FS, _Height),
    InnerWidth is (3 * 3 * FS) + (2 * S),
    draw_horizontal_line(Width),
    draw_margin_rows(LR, InnerWidth, TB), 
    draw_asu_rows(0, LR, S, FS),
    draw_margin_rows(LR, InnerWidth, TB),  
    draw_horizontal_line(Width).

    % err handling for non ints or negatives
asu(LR, TB, S, FS) :-
    format('Validation Error in asu(~w, ~w, ~w, ~w): all arguments must be positive integers.~n', [LR, TB, S, FS]),
    fail.

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
draw_symbol(_, 0).          % base case: if N=0, stop, print nothing
draw_symbol(Char, N) :-     % recursive case:
    N > 0,                  % only run if N is positive
    write(Char),            % print the character once
    N1 is N - 1,            % count down by 1
    draw_symbol(Char, N1).  % do it again

draw_horizontal_line(Width) :-
    draw_symbol('-', Width),  % print Width number of dashes
    nl.                       % then a newline

draw_margin_row(LR, InnerWidth) :-
    write('|'),                   % left border
    draw_symbol(' ', LR),         % left margin
    draw_symbol(' ', InnerWidth), % inner space
    draw_symbol(' ', LR),         % right margin
    write('|'),                   % right border
    nl.                          % newline

draw_margin_rows(_, _, 0).              % base case: TB=0, stop
draw_margin_rows(LR, InnerWidth, TB) :-
    TB > 0,                             % only run if rows remain
    draw_margin_row(LR, InnerWidth),    % print one empty row
    TB1 is TB - 1,                      % count down by 1
    draw_margin_rows(LR, InnerWidth, TB1). % repeat for next row

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
draw_asu_row(Row, LR, S, FS) :-
    write('|'), 
    draw_symbol(' ', LR),
    draw_A_row(Row, FS),
    draw_symbol(' ', S),
    % draw_S_row(Row, FS),   % TODO: S not done yet
    draw_symbol(' ', S),
    draw_U_row(Row, FS),
    draw_symbol(' ', LR),
    write('|'), 
    
    nl.



% repeat one logical row FS times
repeat_asu_row(_, _, _, _, 0).
repeat_asu_row(Row, LR, S, FS, Times) :-
    Times > 0,
    draw_asu_row(Row, LR, S, FS),
    Times1 is Times - 1,
    repeat_asu_row(Row, LR, S, FS, Times1).

% iterate through all 5 logical rows
draw_asu_rows(5, _, _, _).
draw_asu_rows(Row, LR, S, FS) :-
    Row < 5,
    repeat_asu_row(Row, LR, S, FS, FS),
    Row1 is Row + 1,
    draw_asu_rows(Row1, LR, S, FS).