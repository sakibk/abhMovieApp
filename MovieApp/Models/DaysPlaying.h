//
//  DaysPlaying.h
//  MovieApp
//
//  Created by Sakib Kurtic on 28/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DaysPlaying : NSObject

@property (strong,nonatomic) NSDate *playingDate;
@property (strong,nonatomic) NSString *playingDay;
@property (strong,nonatomic) NSMutableArray <NSString*> *playingHours;


@end
