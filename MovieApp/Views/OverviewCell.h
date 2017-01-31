//
//  OverviewTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "Crew.h"

extern NSString * const OverviewCellIdentifier;

@interface OverviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *director;
@property (weak, nonatomic) IBOutlet UILabel *writers;
@property (weak, nonatomic) IBOutlet UILabel *stars;
@property (weak, nonatomic) IBOutlet UILabel *rating;
@property (weak, nonatomic) IBOutlet UILabel *overview;

@property (strong, nonatomic) NSMutableArray <Crew *> *allCrew;
@property (strong, nonatomic) NSMutableString *writersString;
@property (strong, nonatomic) NSMutableString *producentString;
@property (strong, nonatomic) Movie *setupMovie;


-(void) setupWithMovie :(Movie*) singleMovie;

@end
