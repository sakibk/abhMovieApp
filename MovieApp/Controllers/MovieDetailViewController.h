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

@interface MovieDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, CastCollectionCellDelegate,ImageCollectionCellDelegate>

@property (nonatomic,strong) NSNumber* movieID;
@property (nonatomic,strong) Movie *singleMovie;
@property (nonatomic,strong) TVShow *singleShow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isMovie;

-(void)setDetailPoster;

@end
