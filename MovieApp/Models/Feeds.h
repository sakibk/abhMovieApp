//
//  Feeds.h
//  MovieApp
//
//  Created by Sakib Kurtic on 23/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSSParser.h"
#import "RSSItem.h"
@class RLMFeeds;

@interface Feeds : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *desc;

- (id)initWithRSSItem:(RSSItem *)item;
- (id)initWithRLMFeeds:(RLMFeeds *)feed;

@end
