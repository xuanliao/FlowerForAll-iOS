//
//  Exercise.h
//  FlutterApp2
//
//  Created by Dev on 18.01.11.
//  Copyright 2011 Defitech. All rights reserved.
//
//  This class defines fields that mapps whith the column of the database table 'exercises'.
//  The role of this class is to map with the database table in order to easily fetch data from this table.


#import <Foundation/Foundation.h>


@interface Exercise : NSObject {
	double start_ts;
    double stop_ts;
    double frequency_target_hz;
    double frequency_tolerance_hz;
    double duration_expiration_s;
    double duration_exercice_s;
    double duration_exercice_done_ps;
    NSInteger blow_count;
    NSInteger blow_star_count;
}

-(id)init:(double)_start_ts:(double)_stop_ts:(double)_frequency_target_hz:(double)_frequency_tolerance_hz:(double)_duration_expiration_s:(double)_duration_exercice_s:(double)_duration_exercice_done_ps:(NSInteger)_blow_count:(NSInteger)_blow_star_count;


//Properties
@property  double start_ts;
@property  double stop_ts;
@property  double frequency_target_hz;
@property  double frequency_tolerance_hz;
@property  double duration_expiration_s;
@property  double duration_exercice_s;
@property  double duration_exercice_done_ps;
@property  NSInteger blow_count;
@property  NSInteger blow_star_count;



@end
