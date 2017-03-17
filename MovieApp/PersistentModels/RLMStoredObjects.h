//
//  StoredObjects.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "RLMFeeds.h"
#import "RLMovie.h"
#import "RLTVShow.h"

@interface RLMStoredObjects : RLMObject

@property NSString *objectID;
@property RLMArray<RLMFeeds*><RLMFeeds> *storedFeeds;

@property RLMArray<RLMovie*><RLMovie> *storedPopularMovies;
@property RLMArray<RLMovie*><RLMovie> *storedHighestRatedMovies;
@property RLMArray<RLMovie*><RLMovie> *storedLatestMovies;

@property RLMArray<RLTVShow*><RLTVShow> *storedPopularTV;
@property RLMArray<RLTVShow*><RLTVShow> *storedHighestRatedTV;
@property RLMArray<RLTVShow*><RLTVShow> *storedLatestVT;
@property RLMArray<RLTVShow*><RLTVShow> *storedAiringTodayTV;
@property RLMArray<RLTVShow*><RLTVShow> *storedOnAirTV;

-(void)addToStoredFeeds:(RLMFeeds*)feed;

-(void)addToStoredPopularMovies:(RLMovie*)movie;
-(void)addToStoredHighestRatedMovies:(RLMovie*)movie;
-(void)addToStoredLatestMovies:(RLMovie*)movie;

-(void)addToStoredPopularTV:(RLTVShow*)tv;
-(void)addToStoredHighestRatedTV:(RLTVShow*)tv;
-(void)addToStoredLatestTV:(RLTVShow*)tv;
-(void)addToStoredAiringTodayTV:(RLTVShow*)tv;
-(void)addToStoredOnAirTV:(RLTVShow*)tv;

@end
