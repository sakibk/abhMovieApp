//
//  Movie.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (NSString *)description
{
    return [NSString stringWithFormat:@"MovieId: %d, Title: %@, Rating: %@, Poster path: %@, ReleaseDate: %@",self.movieID, self.title, self.rating, self.posterPath, self.releaseDate];
}
@end
