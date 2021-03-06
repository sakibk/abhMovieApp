//
//  FirebaseDetailViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 28/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "PickerCell.h"
#import "ButtonCell.h"
#import "OverviewCell.h"

@interface FirebaseDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,PickerCellDelegate,OverviewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) Movie *singleMovie;
@property (strong,nonatomic) NSNumber *indexPlayDay;
@property (strong, nonatomic) NSMutableArray<Movie*> *allMovies;
@end
