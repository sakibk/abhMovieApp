//
//  OverviewTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "Crew.h"
#import "RLUserInfo.h"

@protocol OverviewCellDelegate <NSObject>

- (void)rateMedia;

@end

extern NSString * const OverviewCellIdentifier;

@interface OverviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *overview;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UILabel *lineSeparator;

@property (strong, nonatomic) NSMutableArray <Crew *> *allCrew;
@property (strong, nonatomic) NSMutableString *writersString;
@property (strong, nonatomic) NSMutableString *producentString;
@property (strong, nonatomic) Movie *setupMovie;
@property (strong, nonatomic) TVShow *setupShow;

@property (strong, nonatomic) NSDictionary *userCredits;
@property RLUserInfo *user;
@property BOOL isLoged;


@property (strong, nonatomic) id<OverviewCellDelegate> delegate;


-(void) setupWithMovie :(Movie*) singleMovie;
-(void) setupWithShow :(TVShow*) singleShow;

@end
