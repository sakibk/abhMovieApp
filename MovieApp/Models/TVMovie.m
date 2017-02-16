//
//  MultiObject.m
//  MovieApp
//
//  Created by Sakib Kurtic on 10/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TVMovie.h"

@implementation TVMovie


-(BOOL)isMovie{
    return [self.mediaType isEqualToString:@"movie"];
}

@end
