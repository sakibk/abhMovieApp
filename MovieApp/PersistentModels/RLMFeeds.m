//
//  RLMFeeds.m
//  MovieApp
//
//  Created by Sakib Kurtic on 14/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLMFeeds.h"

@implementation RLMFeeds

-(id)initWithFeed:(Feeds*)singleFeed{
    self = [super init];
    
    self.title = singleFeed.title;
    self.link = singleFeed.link;
    self.desc = singleFeed.desc;
    
    return self;
}

-(void)setupWithFeed:(Feeds*)singleFeed{
    
    self.title = singleFeed.title;
    self.link = singleFeed.link;
    self.desc = singleFeed.desc;
    
}


@end
