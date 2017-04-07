//
//  SearchCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 06/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"


extern NSString *const searchCellIdentifier;

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchRating;
@property (weak, nonatomic) IBOutlet UILabel *releaseAirDate;

-(void)setSearchCellWithMovie:(Movie *)singleMovie;
-(void)setSearchCellWithTVShow:(TVShow *)singleShow;

@property (strong,nonatomic) UIView *separatorView;
@property BOOL isSideBar;

@end
