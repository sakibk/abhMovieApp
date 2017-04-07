//
//  RLMGenre.m
//  MovieApp
//
//  Created by Sakib Kurtic on 17/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMGenre.h"

@implementation RLMGenre

+ (NSString *)primaryKey {
    return @"genreID";
}

-(id)initWithGenre:(Genre*)genre{
    self = [super init];
    self.genreID=genre.genreID;
    self.genreName = genre.genreName;
    return self;
}

@end
