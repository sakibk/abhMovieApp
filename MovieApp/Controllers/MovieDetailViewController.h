//
//  MovieDetailViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "CastCollectionCell.h"
#import "ImageCollectionCell.h"
#import "OverviewCell.h"
#import "PictureDetailCell.h"
#import "SeasonsCell.h"
#import "SingleReviewCell.h"

@interface MovieDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, CastCollectionCellDelegate,ImageCollectionCellDelegate,OverviewCellDelegate,PictureCellDelegate, SeasonsCellDelegate,SingleReviewCellDelegate>

@property (nonatomic,strong) NSNumber* movieID;
@property (nonatomic,strong) Movie *singleMovie;
@property (nonatomic,strong) TVShow *singleShow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isMovie;

@property (strong, nonatomic) NSDictionary *userCredits;
@property BOOL isLoged;

@end
