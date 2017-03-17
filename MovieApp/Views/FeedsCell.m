//
//  FeedsTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 25/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FeedsCell.h"

NSString* const feedIdentifier= @"FeedCellIdentifier";

@implementation FeedsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setupFeedCell:(RLMFeeds *) singleFeed{
    _feedTitle.text=singleFeed.title;
    _feed.text= singleFeed.desc;
    _sourceLink.text = singleFeed.link;
    self.layer.borderWidth=5;
    self.layer.borderColor=(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]);
}

@end
