//
//  RLTVShow.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLTVShow.h"

@implementation RLTVShow

//+ (NSString *)primaryKey {
//    return @"ShowModelID";
//}

-(void)setupWithShow:(TVShow *)singleObject{
    self.showID=singleObject.showID;
    self.backdropPath=singleObject.backdropPath;
    self.airDate=singleObject.airDate;
    self.name=singleObject.name;
    self.rating=singleObject.rating;
    self.posterPath=singleObject.posterPath;
    self.overview=singleObject.overview;
    self.userRate=singleObject.userRate;
    
}

- (id) initWithShow:(TVShow *)show{
        self=[super init];
    
    self.showID=show.showID ;
    self.backdropPath=show.backdropPath;
    self.airDate=show.airDate;
    self.name=show.name;
    self.rating=show.rating;
    self.posterPath=show.posterPath;
    self.overview=show.overview;
    self.singleGenre=show.singleGenre;
    self.userRate=show.userRate;
    
    return self;
}

@end
