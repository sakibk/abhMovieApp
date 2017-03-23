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

@protocol SeasonsCellDelegate <NSObject>

-(void)allSeasonsView;

@end

extern NSString *const seasonsCellIdentifier;

@interface SeasonsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasons;
@property (weak, nonatomic) IBOutlet UILabel *releaseYears;
@property (weak, nonatomic) IBOutlet UIButton *seeAllButton;

@property (strong,nonatomic) Season* singleSeason;
@property (strong,nonatomic) TVShow *singleShow;
@property (strong,nonatomic) NSNumber *singleShowID;
@property (strong,nonatomic) NSMutableArray<Season *> *allSeasons;

@property (strong,nonatomic) NSMutableArray<NSNumber *> *allYears;
@property (strong,nonatomic) NSMutableString *allYearsString;
@property (strong,nonatomic) NSMutableString *allSeasonString;

@property (strong, nonatomic) id<SeasonsCellDelegate> delegate;
-(void) setupWithShowID:(TVShow *)singleShow;

@end
