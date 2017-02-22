//
//  ListsViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 19/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "RLMovie.h"
#import "RLTVShow.h"

@interface ListsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *noListImage;
@property (weak, nonatomic) IBOutlet UILabel *noListLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) RLMArray<RLMovie*><RLMovie> *movieList;
@property (strong, nonatomic) RLMArray<RLTVShow*><RLTVShow> *showsList;
@property (nonatomic) BOOL isMovie;

@property (nonatomic) BOOL isFavorites;
@property (nonatomic) BOOL isWatchlist;
@property (nonatomic) BOOL isRating;
@end
