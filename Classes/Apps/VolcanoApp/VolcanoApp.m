//
//  VolcanoApp.m
//  FlowerForAll
//
//  Created by Pierre-Mikael Legris on 26.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VolcanoApp.h"
#import "FLAPIBlow.h"
#import "FLAPIX.h"
#import "FlowerController.h"

#import <QuartzCore/QuartzCore.h>

@implementation VolcanoApp


- (void)initVariables {
    
    int mainWidth = self.view.frame.size.width;
    int mainHeight = self.view.frame.size.height - 40 - 20; // 40 for needle + 20 for padding
    lavaHeight = volcano.frame.size.height;
    
    volcano.center = CGPointMake(mainWidth / 2, mainHeight - (lavaHeight / 2));
    burst.center = CGPointMake(mainWidth / 2, mainHeight - lavaHeight - (burst.frame.size.height / 2) + 67);
    burst.hidden = true;
    lavaHidder.center = CGPointMake(mainWidth / 2, mainHeight - (lavaHeight / 2) - 10);
    lavaHidder.hidden = false;

    lavaFrame = lavaHidder.frame;
    
    lavaSmooth = 1;
    lavaReverse = 1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        volcano = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VolcanoApp_volcano.png"] ] autorelease];
        burst = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VolcanoApp_burst.png"] ] autorelease];     
        lavaHidder =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 22, volcano.frame.size.height + 20)];
        lavaHidder.backgroundColor = [UIColor whiteColor];
        
        [self initVariables];
        
        [self.view addSubview:volcano];
        [self.view addSubview:burst];
        [self.view addSubview:lavaHidder];
        
        [self initEvents:self]; // Add observers on FLAPIX events
        
    }
    
    return self;
}

- (IBAction) pressStart:(id)sender {
    if ([[FlowerController currentFlapix] running])
        [[FlowerController currentFlapix] Stop];
    else
        [[FlowerController currentFlapix] Start];
    
    [self.view setNeedsDisplay];
}

- (void)flapixEventFrequency:(FLAPIX *)flapix {
    NSLog(@"Volcano flapixEventFrequency");
    lavaHidder.frame = CGRectOffset(lavaHidder.frame, 0, - lavaReverse);
    
    // oscillates between 1/4 and 3/4 of lavaUp
    if ((lavaReverse > 0 && lavaSmooth == 7) ||
        (lavaReverse < 0 && lavaSmooth == 2)) {
        
        lavaReverse = -1 * lavaReverse;
    }
    
    lavaSmooth = lavaSmooth + lavaReverse;
}

- (void)flapixEventBlowStop:(FLAPIBlow *)blow {
    
    [self.view setNeedsDisplay];
    
    NSLog(@"percent_done: %f", [currentExercice percent_done]);
    
    //Add sound when the goal has been reached for the last blow
    if (blow.goal)
        [self playSystemSound:@"/VolcanoApp_goal.wav"];
    
    //Raise up lava
    lavaHidder.frame = CGRectOffset(lavaFrame, 0, - lavaHeight * [currentExercice percent_done]);
}

- (void)flapixEventExerciceStart:(FLAPIExercice *)exercice {
    [start setTitle:@"Stop Exercice" forState:UIControlStateNormal];
    
    NSLog(@"VolcanoApp flapixEventExerciceStart");
    currentExercice = exercice;
    [self initVariables];
}

- (void)flapixEventExerciceStop:(FLAPIExercice *)exercice {
    [start setTitle:@"Start Exercice" forState:UIControlStateNormal];
    
    lavaHidder.hidden = true;
    burst.hidden = false;
    
    [self playSystemSound:@"/VolcanoApp_explosion.wav"];
}



- (void)playSystemSound:(NSString *)soundFilename{
    //Get the filename of the sound file:
    NSString *path = [NSString stringWithFormat:@"%@%@", 
                      [[NSBundle mainBundle] resourcePath],
                      soundFilename];
    
    //declare a system sound id
    SystemSoundID soundID;
    
    //Get a URL for the sound file
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    
    //Use audio sevices to create the sound
    AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundID);
    
    //Use audio services to play the sound
    AudioServicesPlaySystemSound(soundID);
}



- (void)dealloc {
	[volcano release];
	[burst release];
	[lavaHidder release];
	
    [super dealloc];
}

@end
