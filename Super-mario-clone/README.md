# Super Mario Bros. Remake

[Demo Video](https://youtu.be/lNtlU79pO-M)

A classic platformer in the style of Super Mario Bros., using a free
art pack. Super Mario Bros. was instrumental in the resurgence of video
games in the mid-80s, following the infamous crash shortly after the
Atari age of the late 70s. The goal is to navigate various levels from
a side perspective, where jumping onto enemies inflicts damage and
jumping up into blocks typically breaks them or reveals a powerup.

Art pack:
https://opengameart.org/content/kenney-16x16

Music:
https://freesound.org/people/Sirkoto51/sounds/393818/

## Base code was gameplay with only 1 level and no progression

### Modified Version:

- Reduced player width to fit between chasms blocks better
- Modified level generation to always generate ground under player's spawn location
- Modified level generation to always generate ground under flag spawn location
- Added Key and Lock blocks
- Locked block can be unlocked after obtaining a key
- Added Flag pole at the end of the level
- Flag pole appears after locked block is unlocked
- Once Flag pole is acquired A new level gets generated and player score is kept
- Added Sounds for obtaining key, unlocking locked block, obtaining flag
- Split Flag sprite for easier Quads generation
