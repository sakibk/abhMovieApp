//
//  RLMovie.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMovie.h"
#import "ListType.h"
#import "TrailerVideos.h"
#import "Cast.h"
#import "Crew.h"
#import "ListType.h"
#import "Review.h"

@implementation RLMovie

+ (NSString *)primaryKey {
    return @"movieID";
}

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
    self.singleGenre=movie.singleGenre;
    self.posterPath=movie.posterPath;
    self.overview=movie.overview;
    self.userRate=movie.userRate;
    self.runtime=movie.runtime;
    for(Genre *g in movie.genres)
        [self.genres addObject:[[RLMGenre alloc]initWithGenre:g]];
    for(Crew *cr in movie.crews)
        [self.movieCrew addObject:[[RLMCrew alloc] initWithCrew:cr]];
    for(Cast *cs in movie.casts)
        [self.movieCast addObject:[[RLMCast alloc]initWithCast:cs]];
    for(TrailerVideos *trv in movie.videos)
        [self.videos addObject:[[RLMTrailerVideos alloc] initWithVideo:trv]];
    for(ListType *lt in movie.listType)
        [self.listType addObject:[[RLMListType alloc] initWithRLMListType:lt]];
    for(Review *rw in movie.reviews)
        [self.Reviews addObject:[[RLMReview alloc] initWithReview:rw]];
    
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
-(void)addToStoredVideos:(RLMTrailerVideos*)video{
    BOOL alreadyIn=NO;
    for(RLMTrailerVideos *vd in self.videos)
        if(video.videoID==vd.videoID)
            alreadyIn=YES;
    if(!alreadyIn)
        [self.videos addObject:video];
}

@end
