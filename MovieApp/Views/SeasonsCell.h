//
//  SeasonsCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVShow.h"
#import "Season.h"

extern NSString *const seasonsCellIdentifier;

@interface SeasonsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasons;
@property (weak, nonatomic) IBOutlet UILabel *releaseYears;

@property (strong,nonatomic) Season* singleSeason;
@property (strong,nonatomic) TVShow *singleShow;
@property (strong,nonatomic) NSMutableArray<Season *> *allSeasons;

@property (strong,nonatomic) NSMutableArray<NSNumber *> *allYears;
@property (strong,nonatomic) NSMutableString *allYearsString;
@property (strong,nonatomic) NSMutableString *allSeasonString;

-(void) setupWithShowID:(TVShow *)singleShow;

@end
