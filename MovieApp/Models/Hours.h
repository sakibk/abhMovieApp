//
//  Hours.h
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Seats.h"

@interface Hours : NSObject

@property (strong, nonatomic)NSString *playingHour;
@property (strong, nonatomic)NSNumber *playingHall;
@property (strong, nonatomic)NSMutableArray<Seats*> *seats;


@end
