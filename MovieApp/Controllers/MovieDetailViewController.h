//
//  MovieDetailViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSNumber* movieID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)setDetailPoster;

@end
