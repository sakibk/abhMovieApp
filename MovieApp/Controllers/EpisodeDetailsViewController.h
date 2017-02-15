//
//  EpisodeDetailsViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface EpisodeDetailsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic) Episode *singleEpisode;
@property (strong, nonatomic) NSString *showName;

@end
