//
//  Season.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"

@interface Season : NSObject


@property (strong, nonatomic) NSDate *airDate;
@property (strong, nonatomic) NSNumber *seasonID;
@property (strong, nonatomic) NSNumber *seasonNumber;
@property (strong, nonatomic) NSNumber *episodeCount;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSMutableArray<Episode*> *episodes;

@end
