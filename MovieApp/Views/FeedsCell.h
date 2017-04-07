//
//  FeedsTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 25/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feeds.h"
#import "RLMFeeds.h"

extern NSString * const feedIdentifier;

@interface FeedsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *feedTitle;
@property (weak, nonatomic) IBOutlet UILabel *feed;
@property (weak, nonatomic) IBOutlet UILabel *sourceLink;

-(void) setupFeedCell:(RLMFeeds *) singleFeed;

@end
