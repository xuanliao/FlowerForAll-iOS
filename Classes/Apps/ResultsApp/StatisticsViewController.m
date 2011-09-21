//
//  StatisticsViewController.m
//  FlutterApp2
//
//  Created by Dev on 28.12.10.
//  Copyright 2010 Defitech. All rights reserved.
//
//  Implementation of the StatisticsViewController class


#import "StatisticsViewController.h"
#import "StatisticListViewController.h"

@implementation StatisticsViewController

@synthesize statisticListViewController;


- (id)init {
    self = [super init];
    
    NSLog(@"StatViewController init");
    
    if (self) {
        //Set location of the controller's frame
        self.view.frame = CGRectMake(0.0f, 0.0f, 320.0f, 460.0f);
        
        //Push a StatisticListViewController
        if (statisticListViewController == nil) {
            statisticListViewController = [[StatisticListViewController alloc] initWithNibName:@"StatisticListView" bundle:[NSBundle mainBundle]];
        }
        [self pushViewController:statisticListViewController animated:YES];

    }
    
    return self;
}





- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
    [statisticListViewController release];
}



//Allows view to autorotate in all directions
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
	return YES;
}


@end
