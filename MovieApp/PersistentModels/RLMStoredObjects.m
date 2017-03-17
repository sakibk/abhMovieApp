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

-(void)addToStoredPopularMovies:(RLMovie*)movie{
    [RealmHelper putInto:self.storedPopularMovies :movie];
    //zavrsiti ovo
}
-(void)addToStoredHighestRatedMovies:(RLMovie*)movie{
    
}
-(void)addToStoredLatestMovies:(RLMovie*)movie{
    
}

-(void)addToStoredPopularTV:(RLTVShow*)tv{
    
}
-(void)addToStoredHighestRatedTV:(RLTVShow*)tv{
    
}
-(void)addToStoredLatestTV:(RLTVShow*)tv{
    
}
-(void)addToStoredAiringTodayTV:(RLTVShow*)tv{
    
}
-(void)addToStoredOnAirTV:(RLTVShow*)tv{
    
}


@end
