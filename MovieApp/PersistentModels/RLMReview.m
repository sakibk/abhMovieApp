//
//  RLMReview.m
//  MovieApp
//
//  Created by Sakib Kurtic on 18/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMReview.h"

@implementation RLMReview

-(id)initWithReview:(Review*)rev{
    self = [super init];
    self.author=rev.author;
    self.text =rev.text;
    return self;
}

@end
