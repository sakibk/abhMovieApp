//
//  RLMCast.m
//  MovieApp
//
//  Created by Sakib Kurtic on 19/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMCast.h"

@implementation RLMCast

-(id)initWithCast:(Cast*)cast{
    self= [super init];
    self.castID = cast.castID;
    self.castWithID = cast.castWithID;
    self.castName = cast.castName;
    self.castRoleName = cast.castRoleName;
    self.castImagePath = cast.castImagePath;
    self.castPosterPath = cast.castPosterPath;
    self.castMovieTitle = cast.castMovieTitle;
    self.releaseDate = cast.releaseDate;
    self.mediaType = cast.mediaType;
    return self;
}

@end
