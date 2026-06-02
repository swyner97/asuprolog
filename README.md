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
- Removed redundancies
- Code review and merging

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
