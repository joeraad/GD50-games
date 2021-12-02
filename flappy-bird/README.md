# Flappy bird

A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
the screen, making the player's bird avatar flap its wings and move upwards slightly.
A variant of popular games like "Helicopter Game" that floated around the internet
for years prior. Illustrates some of the most basic procedural generation of game
levels possible as by having pipes stick out of the ground by varying amounts, acting
as an infinitely generated obstacle course for the player.


## Base code was basic flappy bird with standard procedural generation

### Modified version:

- Added randomness to procedural generation
  - Random pipe gap height
  - Random pipe distance height
- Added pause / unpause functionality when player presses P
- Added awarding medals to player based on score
  | No medal | ![alt text][bronze] | ![alt text][silver] |![alt text][gold]|
  | :------: |:-------------------:| :------------------:|:---------------:|
  |    0     |       1 -> 4        |       5 -> 9        |       10+       |

[bronze]: ./bronze_medal.png "Bronze medal"
[silver]: ./silver_medal.png "Silver medal"
[gold]: ./gold_medal.png "Gold medal"
