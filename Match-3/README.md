# Match 3

Match-3 has taken several forms over the years, with its roots in games
like Tetris in the 80s. Bejeweled, in 2001, is probably the most recognized
version of this game, as well as Candy Crush from 2012, though all these
games owe Shariki, a DOS game from 1994, for their inspiration.

The goal of the game is to match any three tiles of the same variety by
swapping any two adjacent tiles; when three or more tiles match in a line,
those tiles add to the player's score and are removed from play, with new
tiles coming from the ceiling to replace them.

## Base code was simpified Match-3 gameplay

### Modified Version:

- Added timer increase on succesfull matches
- Modified tile genartion to ensure patterned tiles only spawn on later levels
  - Patterend tiles give out more points based on their tier
- Modified movement to only allow moves that result in a successful match
- Added board reset when there are no available moves
- Reduced tiles color pallet from 18 colors to 9 colors
- Fixed Game Over screen UI
- Added shiny version of blocks that clear a row or column based on how they got matched `Horizontal / vertical`
