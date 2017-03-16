//
//  Feeds.m
//  MovieApp
//
//  Created by Sakib Kurtic on 23/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Feeds.h"
#import "RSSParser.h"
#import "RSSItem.h"
#import "RLMFeeds.h"

@implementation Feeds

- (NSString *)description
{
    return [NSString stringWithFormat:@"Title: %@, Link: %@, Text: %@",self.title,self.link,self.desc];
}

- (id)initWithRSSItem:(RSSItem *)item {
    
    if (self = [super init]) {
        self.title = item.title;
        self.desc = item.itemDescription;
        self.link = [item.link absoluteString];
    }
    return self;
}

- (id)initWithRLMFeeds:(RLMFeeds *)feed {
    
    self = [super init];
    self.title=feed.title;
    self.desc=feed.desc;
    self.link=feed.link;
    return self;
}

@end
