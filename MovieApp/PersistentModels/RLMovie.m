//
//  RLMovie.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMovie.h"

@implementation RLMovie

//+ (NSString *)primaryKey {
//    return @"movieModelID";
//}

-(void)setupWithMovie:(Movie *)singleObject{
    self.movieID=singleObject.movieID;
    self.backdropPath=singleObject.backdropPath;
    self.releaseDate=singleObject.releaseDate;
    self.title=singleObject.title;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    self.userRate=singleObject.userRate;
    
}


- (id) initWithMovie:(Movie *)movie{
        self=[super init];
    
    self.movieID=movie.movieID;
    self.backdropPath=movie.backdropPath;
    self.releaseDate=movie.releaseDate;
    self.title=movie.title;
    self.rating=movie.rating;
    self.posterPath=movie.posterPath;
    self.overview=movie.overview;
    self.userRate=movie.userRate;
    return self;
}

-(void)addToStoredReviews:(RLMReview*)review{
    [self.Reviews addObject:review];
}
-(void)addToStoredCasts:(RLMCast*)cast{
    [self.movieCast addObject:cast];
}
-(void)addToStoredCrew:(RLMCrew*)crew{
    [self.movieCrew addObject:crew];
}

@end
