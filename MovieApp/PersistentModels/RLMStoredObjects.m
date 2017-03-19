//
//  StoredObjects.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMStoredObjects.h"
#import "RealmHelper.h"

@implementation RLMStoredObjects

+ (NSString *)primaryKey {
    return @"objectID";
}

-(void)addToStoredFeeds:(RLMFeeds*)feed{
//    [[RLMRealm defaultRealm] beginWriteTransaction];
    [self.storedFeeds addObject:feed];
//    [[RLMRealm defaultRealm] commitWriteTransaction];
}

-(void)addToStoredActors:(RLMActor*)actor{
    [self.storedActors addObject:actor];
}

-(void)addToStoredPopularMovies:(RLMovie*)movie{
//    [RealmHelper putInto:self.storedPopularMovies :movie];
    [self.storedPopularMovies addObject:movie];
}
-(void)addToStoredHighestRatedMovies:(RLMovie*)movie{
//    [RealmHelper putInto:self.storedHighestRatedMovies :movie];
    [self.storedHighestRatedMovies addObject:movie];
}
-(void)addToStoredLatestMovies:(RLMovie*)movie{
//    [RealmHelper putInto:self.storedLatestMovies :movie];
    [self.storedLatestMovies addObject:movie];
}
-(void)addToStoredMovieGenres:(RLMGenre*)genre{
//    [RealmHelper putInto:self.storedMovieGenres :genre];
    [self.storedMovieGenres addObject:genre];
}


-(void)addToStoredPopularTV:(RLTVShow*)tv{
//    [RealmHelper putInto:self.storedPopularTV :tv];
    [self.storedPopularTV addObject:tv];
}
-(void)addToStoredHighestRatedTV:(RLTVShow*)tv{
//    [RealmHelper putInto:self.storedHighestRatedTV :tv];
    [self.storedHighestRatedTV addObject:tv];
}
-(void)addToStoredLatestTV:(RLTVShow*)tv{
//    [RealmHelper putInto:self.storedLatestTV :tv];
    [self.storedLatestTV addObject:tv];
}
-(void)addToStoredAiringTodayTV:(RLTVShow*)tv{
//    [RealmHelper putInto:self.storedAiringTodayTV :tv];
    [self.storedAiringTodayTV addObject:tv];
}
-(void)addToStoredOnAirTV:(RLTVShow*)tv{
//    [RealmHelper putInto:self.storedOnAirTV :tv];
    [self.storedOnAirTV addObject:tv];
}
-(void)addToStoredTVGenres:(RLMGenre*)genre{
//    [RealmHelper putInto:self.storedTVGenres :genre];
    [self.storedTVGenres addObject:genre];
}


@end
