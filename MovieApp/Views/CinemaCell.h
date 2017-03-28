//
//  CinemaCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

extern NSString *const cinemaCellIdentifier;

@interface CinemaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backdropImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (weak, nonatomic) IBOutlet UILabel *rating;

-(void)setupWithMovie:(Movie*)mov;

@end
