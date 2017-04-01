//
//  PlayingHall.h
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Seats.h"
#import "DaysPlaying.h"

@interface PlayingHall : NSObject

@property (strong, nonatomic)NSNumber *playingHallID;
@property (strong, nonatomic)NSMutableArray<DaysPlaying*> *daysPlaying;
@property (strong, nonatomic)NSMutableArray<NSString*> *hoursPlaying;

@end
