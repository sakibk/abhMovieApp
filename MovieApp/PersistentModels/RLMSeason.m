//
//  RLMSeason.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMSeason.h"

@implementation RLMSeason

-(id)initWithSeason:(Season*)season{
    self= [super init];
    self.seasonID=season.seasonID;
    self.seasonNumber=season.seasonNumber;
    self.episodeCount=season.episodeCount;
    self.airDate =season.airDate;
    self.posterPath=season.posterPath;
    
    return self;
}

-(void)addToStoredEpisodes:(RLMEpisode*)ep{
    [self.episodes addObject:ep];
}

@end
