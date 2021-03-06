//
//  VolcanoApp.h
//  FlowerForAll
//
//  Created by Pierre-Mikael Legris on 26.08.11.
//  Copyright 2011 fondation Defitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAPIExercice.h"
#include <AudioToolbox/AudioToolbox.h>
#import "FlowerApp.h"

@interface VolcanoApp : FlowerApp {
    IBOutlet UIButton *start;
    UIImageView *volcano;
    UIImageView *burst;
    UIView *lavaHidder;
    
    IBOutlet UILabel *starLabel;
    
    CGRect lavaFrame;
    
    float mainWidth;
    float mainHeight;
    float lavaWidth;
    float lavaHeight;
    
}

@property (nonatomic, retain) UIImageView *volcano;
@property (nonatomic, retain) UIImageView *burst;
@property (nonatomic, retain) UIView *lavaHidder;

- (void)playSystemSound:(NSString *)soundFilename;
- (IBAction) pressStart:(id) sender;

@end
