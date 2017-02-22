//
//  UserInfo.m
//  MovieApp
//
//  Created by Sakib Kurtic on 20/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(id)init{
    self=[super init];
    return self;
}

- (id) initWithObject:(UserInfo *)user{
    self = [super init];
    
    self.name=user.name;
    self.userID=user.userID;
    self.userName=user.userName;
    self.session=user.session;
    self.favoriteMovies=user.favoriteMovies;
    self.favoriteShows=user.favoriteShows;
    self.watchlistMovies=user.watchlistMovies;
    self.watchlistShows=user.watchlistShows;
    self.ratedMovies=user.ratedMovies;
    self.ratedShows=user.ratedShows;
    
    return self;
}

@end
