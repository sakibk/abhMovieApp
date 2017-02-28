//
//  NotificationListViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 28/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "SearchCell.h"

@interface NotificationListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL isMovie;

@property (weak, nonatomic) UIView *separatorView;
@property (strong, nonatomic) NSMutableArray<Movie*> *notificationMovies;
@property (strong, nonatomic) NSMutableArray<TVShow*> *notificationShows;

-(void)initWithNotificationMovie;
-(void)initWithNotificationShow;
@end
