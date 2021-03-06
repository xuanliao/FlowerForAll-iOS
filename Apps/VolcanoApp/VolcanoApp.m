//
//  VolcanoApp.m
//  FlowerForAll
//
//  Created by Pierre-Mikael Legris on 26.08.11.
//  Copyright 2011 fondation Defitech. All rights reserved.
//

#import "VolcanoApp.h"
#import "FLAPIBlow.h"
#import "FLAPIX.h"
#import "FlowerController.h"

#import <QuartzCore/QuartzCore.h>

@implementation VolcanoApp

@synthesize volcano, lavaHidder, burst;
# pragma mark FlowerApp overriding

/** Used to put in as label on the App Menu (Localized)**/
+(NSString*)appTitle {
    return NSLocalizedStringFromTable(@"Volcano Game",@"VolcanoApp",@"VolcanoApp Title");
}

- (void)refreshStartButton {
    if ([FlowerController shouldShowStartButton]) {
        [self.view bringSubviewToFront:start]; 
    } else {
        [self.view sendSubviewToBack:start];
        
    }
}

-(void)flapixEventStart:(FLAPIX *)flapix {
    [self refreshStartButton];
}

-(void)flapixEventStop:(FLAPIX *)flapix {
    [self refreshStartButton];
}


- (void)initVariables {
    float correctedHeight;
    float adjustBurst;
    if ( [UIScreen mainScreen].bounds.size.height > 500 && [UIScreen mainScreen].bounds.size.height < 700 ) {
        correctedHeight = [UIScreen mainScreen].bounds.size.height - 80; // for iphone 5
        adjustBurst = self.view.frame.size.height/4.6; // kind of hack to adjust burst on top of volcano; for the moment, the burst is slightly higher on the ipad than on the iphone
    } else if ( [UIScreen mainScreen].bounds.size.height > 900 ) {
        correctedHeight = self.view.frame.size.height - 20; // 40 for needle + 20 for padding
        adjustBurst = self.view.frame.size.height/3.8; // kind of hack to adjust burst on top of volcano; for the moment, the burst is slightly higher on the ipad than on the iphone
    } else {
        correctedHeight = self.view.frame.size.height - 20; // 40 for needle + 20 for padding
        adjustBurst = self.view.frame.size.height/4.6; // kind of hack to adjust burst on top of volcano; for the moment, the burst is slightly higher on the ipad than on the iphone
    }
    //float adjustBurst = 100.0f; // kind of hack to adjust burst on top of volcano

    
    volcano.center = CGPointMake(mainWidth / 2, correctedHeight - (lavaHeight / 2));
    burst.center = CGPointMake(mainWidth / 2, correctedHeight - lavaHeight - (burst.frame.size.height / 2) + adjustBurst);
    burst.hidden = true;
    lavaHidder.center = CGPointMake(mainWidth / 2, correctedHeight - (lavaHeight / 2));
    lavaHidder.hidden = false;

    lavaFrame = lavaHidder.frame;
    starLabel.text = @"0";
    [self refreshStartButton];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        mainWidth = self.view.frame.size.width;
        mainHeight = self.view.frame.size.height;
        
        UIImageView *tempvolcano = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VolcanoApp_volcano.png"]];
        self.volcano = tempvolcano;
        [tempvolcano release];
        [volcano setFrame:CGRectMake(0, 0, mainWidth * 0.9, volcano.frame.size.height * mainWidth * 0.9 / volcano.frame.size.width)];
        volcano.contentMode = UIViewContentModeScaleAspectFit;
        
        UIImageView *tempburst = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VolcanoApp_burst.png"]];
        self.burst = tempburst;
        [tempburst release];
        [burst setFrame:CGRectMake(0, 0, mainWidth * 0.9, burst.frame.size.height * mainWidth * 0.9 / burst.frame.size.width)];
        burst.contentMode = UIViewContentModeScaleAspectFit;
        
        
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            lavaWidth = 46;
        } else {
            lavaWidth = 19; //depending of volcano image
        }
        lavaHeight = volcano.frame.size.height;
        
        UIView *templavaHider = [[UIView alloc] initWithFrame:CGRectMake(0, 0, lavaWidth, lavaHeight)];
        self.lavaHidder = templavaHider;
        [templavaHider release];
        lavaHidder.backgroundColor = [UIColor whiteColor];
        
         [start setTitle:NSLocalizedStringFromTable(@"Start Exercise",@"VolcanoApp",@"Start Button") 
                forState:UIControlStateNormal];
        
        [self initVariables];
        
        [self.view addSubview:volcano];
        [self.view addSubview:burst];
        [self.view addSubview:lavaHidder];

        [self refreshStartButton];
    }
    
    return self;
}


- (IBAction) pressStart:(id)sender {
    if ([[FlowerController currentFlapix] exerciceInCourse]) {
        NSLog(@"pressStart: stop");
        [[FlowerController currentFlapix] exerciceStop];
    } else {
        NSLog(@"pressStart: start");
        [[FlowerController currentFlapix] exerciceStart];
    }
}

bool debug_events = NO;
- (void)flapixEventFrequency:(double)frequency in_target:(BOOL)good current_exercice:(double)percent_done {
    if (! [[FlowerController currentFlapix] exerciceInCourse]) return;
    if (percent_done > 0)
        lavaHidder.frame =  CGRectOffset(lavaFrame, 0, - lavaHeight * percent_done);
}

- (void)flapixEventBlowStop:(FLAPIBlow *)blow {
     if (debug_events) NSLog(@"VOLCANO flapixEvent  BlowStop");
    
    if (! [[FlowerController currentFlapix] exerciceInCourse]) return;
    float percent = [[[FlowerController currentFlapix] currentExercice] percent_done];
    //NSLog(@"percent_done: %f", percent);
    
    //Add sound when the goal has been reached for the last blow
    if (blow.goal) {
        [self playSystemSound:@"/VolcanoApp_goal.wav"];
       
    }
    starLabel.text = [NSString stringWithFormat:@"%i", 
                      [[[FlowerController currentFlapix] currentExercice] blow_star_count]];
    //Raise up lava
    lavaHidder.frame = CGRectOffset(lavaFrame, 0, - lavaHeight * percent);
    [self refreshStartButton];
    [self.view setNeedsDisplay];
}

- (void)flapixEventExerciceStart:(FLAPIExercice *)exercice {
    if (debug_events) NSLog(@"VOLCANO flapixEvent  ExerciceStart");
    [self initVariables];
}

- (void)flapixEventExerciceStop:(FLAPIExercice *)exercice {
    if (debug_events) NSLog(@"VOLCANO flapixEvent  ExerciceStop");
    
    if (exercice.duration_exercice_s <= exercice.duration_exercice_done_s) {
        lavaHidder.hidden = true;
        burst.hidden = false;
        [self playSystemSound:@"/VolcanoApp_explosion.wav"];
    }
    [self.view setNeedsDisplay];
    [self refreshStartButton];
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
    id temp1 = volcano;
    volcano = nil;
    [temp1 release];
    id temp2 = burst;
    burst = nil;
    [temp2 release];
    id temp3 = lavaHidder;
    lavaHidder = nil;
    [temp3 release];
	
    [super dealloc];
}

@end
