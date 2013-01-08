Flower Breath iOS
=================

Many young people suffering from respiratory problems must perform daily physiotherapy for airway clearance with a PEP medical device

By breathing out with a moderate force through a resistance, a positive pressure is generated in the airways, helping to keep them open. This positive pressure allows airflow to get beneath the areas of mucus obstruction and move the mucus toward the larger airways, where it can be coughed out.

**Project Homepage: ** [http://www.defitech.ch/FlowerForAll-en](http://www.defitech.ch/FlowerForAll-en)

## WRITE A GAME
If you want to write a game, please read:
 [Apps/HOWTO_WRITE_A_GAME.md](https://github.com/defitech/FlowerForAll-iOs/blob/master/Apps/HOWTO_WRITE_A_GAME.md)

## KNOWN BUGS 
- they must be some memory leaks.. and some crashes are caused by some runnning conditions that happend more often iPad and older iPhone models.
- it would be nice to have an objective-c expert do some code review.. 


## DOCUMENTATION 
- Complete "How To develop a game" document, with ergonomic guidlines and events sequence description
 
## PARAMETERS - MONITORING MODE
Actually the soft is design in a "target" or "goal" mode, but some people would like to use is as a simpe monitoring device for their exercices.  
For exemple an Adult, would not do "games" with it but he will be interested in having historical statistics.  
This would be easily achived by recording every blows in the database, independently of exercices start / stop.   
But we need to create an interface for viewing this data..

## PARAMETERS - SETTINGS
- Makes profiles editables / removables .
- The model is ready to be implemented

## COSMETICS
- Refactor FLOWER BREATH logo and icon

## MONITORING
- Rewrite the history monitor in OpenGL or Quartz

- Add a current-blow percentage view.  
 in the needleGL view add a progress view (vertical) that shows the persent of blowduration achieved.

## APPS MENU
- Placement is now manual.  
  When we will have more apps, 
  (more than one page) we will have to develop an automatic placement
  for FlowerApp subclassing applications.

## VOLCANO APPS
- It's nice but minimalist, 
- It would be great to have some animations and litlle blows off 

## GAMES !
- Integrate some game engine such as unity and cocos2d

## FLAPI - FLAPIX
- Is  "code spagetthi" fashionned
It would be nice to have someone exetrnal do some revieweing / refactoring

## AUDIO FEEDBACK
- Add a nice audio feedback for someone who would do it's exercice without holding the iPhone.

## SOUND PROCESSING
- Less latency could be achieved using remote i/o audio unit
see: https://developer.apple.com/library/ios/#samplecode/aurioTouch/Introduction/Intro.html

- is not perfect but functionnal..
- we will probably need to rewrite FLAPI if IAV does not open their code

## R & D
- Possible with a bluetooth headset ?
- Other microphone
- Make a special piece of plastic to fix the microphone to the flutter



