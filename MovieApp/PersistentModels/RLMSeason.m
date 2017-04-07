//
//  RLMSeason.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMSeason.h"
#import "Episode.h"

@implementation RLMSeason

-(id)initWithSeason:(Season*)season{
    self= [super init];
    self.seasonID=season.seasonID;
    self.seasonNumber=season.seasonNumber;
    self.episodeCount=season.episodeCount;
    self.airDate =season.airDate;
    self.posterPath=season.posterPath;
    for(Episode *e in season.episodes)
        [self.episodes addObject:[[RLMEpisode alloc] initWithEpisode:e]];
    
    return self;
}

-(void)addToStoredEpisodes:(RLMEpisode*)ep{
    [self.episodes addObject:ep];
}

@end
