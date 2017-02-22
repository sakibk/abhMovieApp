//
//  RLUserInfo.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLUserInfo.h"

@implementation RLUserInfo


- (id) initWithUser:(UserInfo *)user{
        self=[super init];
    
    self.name=user.name;
    self.userID=user.userID;
    self.userName=user.userName;
    self.session=[self.session initWithToken:user.session];
   for (Movie *movie in user.favoriteMovies){
       [self.favoriteMovies addObject:[[RLMovie alloc]initWithMovie:movie]];
    }
    for (TVShow *show in user.favoriteShows){
        [self.favoriteShows addObject:[[RLTVShow alloc]initWithShow:show]];
    }
    
    for (Movie *movie in user.watchlistMovies){
        [self.watchlistMovies addObject:[[RLMovie alloc]initWithMovie:movie]];
    }
    for (TVShow *show in user.watchlistShows){
        [self.watchlistShows addObject:[[RLTVShow alloc]initWithShow:show]];
    }
    for (Movie *movie in user.ratedMovies){
        [self.ratedMovies addObject:[[RLMovie alloc]initWithMovie:movie]];
    }
    for (TVShow *show in user.ratedShows){
        [self.ratedShows addObject:[[RLTVShow alloc]initWithShow:show]];
    }
    
    return self;
}


-(void)addToFavoriteMovies:(RLMovie*)movie{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [self.favoriteMovies addObject:movie];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

-(void)deleteFavoriteMovies:(RLMovie*)movie{
    int i,j = 0;
    BOOL didFound=NO;
    for (i=0;i<[self.favoriteMovies count]; i--) {
        if([[[self.favoriteMovies objectAtIndex:i] movieID] isEqualToNumber:movie.movieID]){
            j=i;
            didFound=YES;
        }
    }
    if(didFound){
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [self.favoriteMovies removeObjectAtIndex:j];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}

-(void)addToWatchlistMovies:(RLMovie*)movie{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [self.watchlistMovies addObject:movie];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

-(void)deleteWatchlistMovies:(RLMovie*)movie{
    int i,j = 0;
    BOOL didFound=NO;
    for (i=0;i<[self.watchlistMovies count]; i--) {
        if([[[self.watchlistMovies objectAtIndex:i] movieID] isEqualToNumber:movie.movieID]){
            j=i;
            didFound=YES;
        }
    }
    if(didFound){
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [self.watchlistMovies removeObjectAtIndex:j];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}

-(void)addToFavoriteShows:(RLTVShow*)show{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [self.favoriteShows addObject:show];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

-(void)deleteFavoriteShows:(RLTVShow*)show{
    int i,j = 0;
    BOOL didFound=NO;
    for (i=0;i<[self.favoriteShows count]; i--) {
        if([[[self.favoriteShows objectAtIndex:i] showID] isEqualToNumber:show.showID]){
            j=i;
            didFound=YES;
        }
    }
    if(didFound){
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [self.favoriteShows removeObjectAtIndex:j];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}

-(void)addToWatchlistShows:(RLTVShow*)show{
    [[RLMRealm defaultRealm] beginWriteTransaction];
    [self.watchlistShows addObject:show];
    [[RLMRealm defaultRealm] commitWriteTransaction];
}

-(void)deleteWatchlistShows:(RLTVShow*)show{
    int i,j = 0;
    BOOL didFound=NO;
    for (i=0;i<[self.watchlistShows count]; i--) {
        if([[[self.watchlistShows objectAtIndex:i] showID] isEqualToNumber:show.showID]){
            j=i;
            didFound=YES;
        }
    }
    if(didFound){
        [[RLMRealm defaultRealm] beginWriteTransaction];
        [self.watchlistShows removeObjectAtIndex:j];
        [[RLMRealm defaultRealm] commitWriteTransaction];
    }
}


@end
