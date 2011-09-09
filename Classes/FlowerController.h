//
//  FlowerController.h
//  FlutterApp2
//
//  Created by Pierre-Mikael Legris on 07.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NeedleGL.h"
#import "SettingsViewController.h"
#import "StatisticsViewController.h"
#import "FLAPIX.h"
#import "HistoryViewController.h"

@interface FlowerController : UIViewController <UIActionSheetDelegate> {
    UIView *mainView;
    HistoryViewController *historyViewController;
    
   

}

@property (nonatomic, retain) IBOutlet UIView *mainView;
@property (nonatomic, retain) HistoryViewController *historyViewController;

// show navigation action sheet
+ (void) showNav;

+ (FLAPIX*) currentFlapix;

// get Settings view Controller
+ (SettingsViewController*) getSettingsViewController;

// get Statistics view Controller
+ (StatisticsViewController*) getStatisticsViewController;

+(void)setCurrentMainController:(UIViewController*)thisController;

@end
