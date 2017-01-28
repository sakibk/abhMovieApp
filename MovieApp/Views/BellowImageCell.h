//
//  BellowImageTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

extern NSString * const BellowImageCellIdentifier;

@interface BellowImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UILabel *releaseDate;
@property (weak, nonatomic) IBOutlet UILabel *genres;
@property (strong, nonatomic) NSMutableString *genreString;

-(void) setupWithMovie:(Movie *)singleMovie;

@end
