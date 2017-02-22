//
//  RLMovie.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMovie.h"

@implementation RLMovie

-(id) init{
    self=[super init];
    return self;
}

-(void)setupWithMovie:(Movie *)singleObject{
    self.movieID=singleObject.movieID;
    self.backdropPath=singleObject.backdropPath;
    self.releaseDate=singleObject.releaseDate;
    self.title=singleObject.title;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    
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
    return self;
}

@end
