//
//  RLMImagePaths.m
//  MovieApp
//
//  Created by Sakib Kurtic on 21/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMImagePaths.h"

@implementation RLMImagePaths

-(id)initWithPaths:(ImagePathUrl*)image{
    self = [super init];
    self.posterPath = image.posterPath;
    return self;
}

@end
