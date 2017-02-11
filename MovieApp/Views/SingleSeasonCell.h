//
//  SingleSeasonCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Season.h"
#import "SingleSeasonCell.h"

extern NSString *const singleSeasonCellIdentifier;

@interface SingleSeasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasonTitle;
@property (weak, nonatomic) IBOutlet UILabel *seasonRealeaseDate;
@property (weak, nonatomic) IBOutlet UILabel *seasonRating;

-(void)setupWithSeason:(Season*)seasonDetails;

@end
