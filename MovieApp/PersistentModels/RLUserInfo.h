//
//  RLUserInfo.h
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Realm/Realm.h>
#import "UserInfo.h"
#import "RLMovie.h"
#import "RLTVShow.h"
#import "RLToken.h"

@interface RLUserInfo : RLMObject

@property NSNumber<RLMInt> *userID;
@property NSString *name;
@property NSString *userName;
@property RLToken *session;
@property RLMArray<RLMovie*><RLMovie> *favoriteMovies;
@property RLMArray<RLTVShow*><RLTVShow> *favoriteShows;
@property RLMArray<RLMovie*><RLMovie> *watchlistMovies;
@property RLMArray<RLTVShow*><RLTVShow> *watchlistShows;
@property RLMArray<RLMovie*><RLMovie> *ratedMovies;
@property RLMArray<RLTVShow*><RLTVShow> *ratedShows;

-(void)addToWatchlistShows:(RLTVShow*)show;
-(void)addToFavoriteShows:(RLTVShow*)show;
-(void)addToRatedShows:(RLTVShow*)show;
-(void)addToWatchlistMovies:(RLMovie*)movie;
-(void)addToFavoriteMovies:(RLMovie*)movie;
-(void)addToRatedMovies:(RLMovie*)movie;

-(void)deleteWatchlistShows:(RLTVShow*)show;
-(void)deleteFavoriteShows:(RLTVShow*)show;
-(void)deleteRatedShows:(RLTVShow*)show;
-(void)deleteWatchlistMovies:(RLMovie*)movie;
-(void)deleteFavoriteMovies:(RLMovie*)movie;
-(void)deleteRatedMovies:(RLMovie*)movie;






- (id) initWithUser:(UserInfo *)user;
@end

RLM_ARRAY_TYPE(RLUserInfo);
