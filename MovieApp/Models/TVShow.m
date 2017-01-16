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
    return [NSString stringWithFormat:@"ShowId: %d, Title: %@, Rating: %@, Poster path: %@, ReleaseDate: %@",self.showID, self.title, self.rating, self.posterPath, self.airDate];
}

@end
