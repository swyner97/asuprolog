# CSE 259 - Project 1: ASU Printer in Prolog

## Project Description
This project implements a Prolog program that prints the letters "ASU" 
in ASCII art format inside a bounding box. The output is controlled by 
four parameters:

- **LeftRightMargin** - empty space on the left and right sides inside the box
- **BottomTopMargin** - empty lines on the top and bottom inside the box
- **SpaceBetweenCharacters** - horizontal gap between each letter
- **FontSize** - controls the size of each letter

### Usage
```prolog
?- asu(LeftRightMargin, BottomTopMargin, SpaceBetweenCharacters, FontSize).
```

### Example
```prolog
?- asu(2, 2, 4, 3).
```

---

## Team Members & Contributions

### Dhruv Jain

**Contributions:**
- Reviewed and merged team code contributions
- Refactored redundant predicates (repeat_A_row, repeat_U_row, draw_A, draw_U, etc.) into generalized reusable predicates
- Unified row-rendering logic for all letter implementations
- Eliminated duplicate width calculations and removed unused height computations
- Fixed control-flow issue caused by missing cut (!) in asu/4
- Removed dead code and cleaned up unused variables
- Corrected outdated comments and improved code documentation
- Assisted with testing, debugging, and overall program optimization

---

### Nick Leigh

**Contributions:**
- Implemented the letter S logic
- Conducted unit and integration testing

---

### Sarah Wyner

**Contributions:**
- Implemented letter U logic and drawing predicates
- Implemented bounding box margins and borders
- Integrated dimension calculations into main predicate
- Added input validation and error handling


---

## Files
- `asu.pl` - main Prolog source code
- `README.txt` - this file
