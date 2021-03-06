//
//  FlowerApp.h
//  FlowerForAll
//
//  Created by Pierre-Mikael Legris (Perki) on 08.09.11.
//  Copyright 2011 fondation Defitech All rights reserved.
//

//  File Naming convention
//  If you App Name is "MyApp" then all you files should start with "MyApp"
//  Translations 

#import <Foundation/Foundation.h>
#import "FLAPIX.h"

@interface FlowerApp : UIViewController

/** 
 * With call initWithName appropriatly 
 * Override if you need custom loading
 **/
+(FlowerApp*)autoInit;

/** the AppName (code) not displayed to the user **/
+(NSString*)appName;
/** Used to put a button on the App Menu **/
+(UIImage*)appIcon;
/** Used to put in as label on the App Menu (Localized)**/
+(NSString*)appTitle;

/**
 * Add FLAPIX Listeners
 * Will automatically add all observers ..
 * may be overriden  for efficiency 
 */
-(void)addObservers;

/**  
 * FLAPIX start  !! check   flapixEventExerciceStart
 * Override this method to catch 
 **/
-(void)flapixEventStart:(FLAPIX *)flapix;
/** 
 * FLAPIX stop !! check   flapixEventExerciceStop
 * Override this method to catch 
 **/
-(void)flapixEventStop:(FLAPIX *)flapix;



/**  
 * A new exercice start  
 * Override this method to catch 
 **/
-(void)flapixEventExerciceStart:(FLAPIExercice *)exercice;
/** 
 * Exercice did finished  
 * Override this method to catch 
 **/
-(void)flapixEventExerciceStop:(FLAPIExercice *)exercice;


/** 
 * Sound level changes. Value is from 0 to 1, this signal is equivalento a vu-meter 
 * Override this method to catch 
 **/
-(void)flapixEventLevel:(float)soundLevel;
/**  
 * return the actual Frequency 
 * percent done is between 0 and 1 if exercice in cource, -1 if not in course
 * Override this method to catch 
 **/
- (void)flapixEventFrequency:(double)frequency in_target:(BOOL)good current_exercice:(double)percent_done ;
/**  
 * A blow started  
 * Override this method to catch 
 **/
-(void)flapixEventBlowStart:(FLAPIBlow *)blow;
/**  
 * A blow finished  
 * Override this method to catch 
 **/
-(void)flapixEventBlowStop:(FLAPIBlow *)blow;

@end
