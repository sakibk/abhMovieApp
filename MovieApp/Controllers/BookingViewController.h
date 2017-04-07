//
//  BookingViewController.h
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerCell.h"
#import "Movie.h"
#import "TwoPickerCell.h"
#import "Hours.h"
#import "CollectionSeatsCell.h"

@interface BookingViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PickerCellTwoDelegate,TwoPickerCellDelegate, SeatsCollectionDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Movie *selectedMovie;
@property (strong, nonatomic) NSMutableArray<Movie*> *allMovies;
@property (strong, nonatomic) Hours *selectedHours;

@end
