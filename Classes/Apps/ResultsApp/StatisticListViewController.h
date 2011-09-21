//
//  StatisticListViewController.h
//  FlutterApp2
//
//  Created by Dev on 28.12.10.
//  Copyright 2010 Defitech. All rights reserved.
//
//  This class is the table view controller for the main statistic list.


#import <UIKit/UIKit.h>

#import "CorePlot-CocoaTouch.h"

@class DayStatisticListViewController;


@interface StatisticListViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
	
	//The table view
	IBOutlet UITableView *statisticListTableView;
	
	//Arrays used to store dates and exercises
    NSArray* exerciseDays;
    
	//Stores the currently selected row in the table
	NSInteger currentlySelectedRow;
	
	//Child view controller
    DayStatisticListViewController *dayStatisticListViewController;
	
}


//Properties
@property (nonatomic, retain) IBOutlet UITableView *statisticListTableView;

@property (nonatomic, retain) NSArray *exerciseDays;

@property NSInteger currentlySelectedRow;

@property (nonatomic, retain) DayStatisticListViewController *dayStatisticListViewController;



@end
