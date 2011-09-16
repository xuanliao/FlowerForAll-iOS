//
//  FlowerController.h
//  FlutterApp2
//
//  Created by Pierre-Mikael Legris on 07.06.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NeedleGL.h"
#import "FLAPIX.h"
#import "HistoryView.h"
#import "ParametersApp.h"

@interface FlowerController : UIViewController <UIActionSheetDelegate> {
    UIView *mainView;
}

@property (nonatomic, retain) IBOutlet UIView *mainView;

// show navigation action sheet
+ (void) showNav;


+ (FlowerController*) currentFlower;

+ (FLAPIX*) currentFlapix;

/** 
 *called by Button on the UINavBar 
 *This is a shortcut to a pushMenu static call
 **/
- (void)goToMenu: (id) sender  ;

/** show The Menu **/
+ (void)pushMenu ;

/** Promote an App as current Main COntroller **/ 
+ (void) pushApp:(NSString*) flowerApp ;
+ (void) pushApp:(NSString*) flowerApp withUIViewAnimation:(UIViewAnimationTransition)transition;

+ (void) setCurrentMainController:(UIViewController*)thisController;
+ (void) setCurrentMainController:(UIViewController*)thisController withUIViewAnimation:(UIViewAnimationTransition)transition;
@end
