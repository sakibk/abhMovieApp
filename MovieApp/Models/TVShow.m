//
//  TVShow.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TVShow.h"

@implementation TVShow

- (NSString *)description
{
    return [NSString stringWithFormat:@"ShowId: %@, Title: %@, Rating: %@, Poster path: %@, ReleaseDate: %@",self.showID, self.name, self.rating, self.posterPath, self.airDate];
}

-(void)setupWithTVMovie:(TVMovie *)singleObject{
    self.showID=singleObject.TVMovieID;
    self.backdropPath=singleObject.backdropPath;
    self.airDate=singleObject.airDate;
    self.genreIds=singleObject.genreIds;
    self.name=singleObject.name;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    
}

@end
