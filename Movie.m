//
//  Movie.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Movie.h"
#import "TVMovie.h"

@implementation Movie

- (NSString *)description
{
    return [NSString stringWithFormat:@"MovieId: %@, Title: %@, Rating: %@, Poster path: %@, ReleaseDate: %@ , BackdropPath: %@",self.movieID, self.title, self.rating, self.posterPath, self.releaseDate, self.backdropPath];
}

-(void)setupWithTVMovie:(TVMovie *)singleObject{
    self.movieID=singleObject.TVMovieID;
    self.backdropPath=singleObject.backdropPath;
    self.releaseDate=singleObject.releaseDate;
    self.genreIds=singleObject.genreIds;
    self.title=singleObject.title;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    
}

@end
