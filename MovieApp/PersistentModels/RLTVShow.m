//
//  RLTVShow.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLTVShow.h"
#import "ListType.h"
#import "Genre.h"
#import "Cast.h"
#import "Crew.h"
#import "Season.h"
#import "ListType.h"

@implementation RLTVShow

+ (NSString *)primaryKey {
    return @"showID";
}


-(void)setupWithShow:(TVShow *)singleObject{
    self.showID=singleObject.showID;
    self.backdropPath=singleObject.backdropPath;
    self.airDate=singleObject.firstAirDate;
    self.firstAirDate=singleObject.firstAirDate;
    self.lastAirDate=singleObject.lastAirDate;
    self.name=singleObject.name;
    self.rating=singleObject.rating;
    self.singleGenre = singleObject.singleGenre;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    self.userRate=singleObject.userRate;
    
}

- (id) initWithShow:(TVShow *)show{
        self=[super init];
    
    self.showID=show.showID ;
    self.backdropPath=show.backdropPath;
    self.airDate=show.firstAirDate;
    self.firstAirDate=show.firstAirDate;
    self.lastAirDate=show.lastAirDate;
    self.name=show.name;
    self.rating=show.rating;
    self.posterPath=show.posterPath;
    self.singleGenre = show.singleGenre;
    self.overview=show.overview;
    self.userRate=show.userRate;
    self.seasonCount = show.seasonCount;
    for(Genre *g in show.genres)
        [self.genres addObject:[[RLMGenre alloc]initWithGenre:g]];
    if([show.runtime count]>1)
        self.StartRuntime=[show.runtime objectAtIndex:0];
    if([show.runtime count]>2)
        self.endRuntime=[show.runtime objectAtIndex:1];
    for(Cast *cs in show.casts)
        [self.showCast addObject:[[RLMCast alloc] initWithCast:cs]];
    for(Crew *cr in show.crews)
        [self.showCrew addObject:[[RLMCrew alloc] initWithCrew:cr]];
    for(Season *s in show.seasons)
        [self.seasons addObject:[[RLMSeason alloc] initWithSeason:s]];
    for(ListType *lt in show.listType)
        [self.listType addObject:[[RLMListType alloc] initWithRLMListType:lt]];
    return self;
}

-(void)addToStoredSeasons:(RLMSeason*)season{
    [self.seasons addObject:season];
}

-(void)addToStoredCasts:(RLMCast*)cast{
    [self.showCast addObject:cast];
}

-(void)addToStoredCrew:(RLMCrew*)crew{
    [self.showCrew addObject:crew];
}

@end
