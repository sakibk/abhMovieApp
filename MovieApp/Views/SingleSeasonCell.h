//
//  SingleSeasonCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"
#import "SingleSeasonCell.h"

extern NSString *const singleSeasonCellIdentifier;

@interface SingleSeasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *episodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *episodeRealeaseDate;
@property (weak, nonatomic) IBOutlet UILabel *episodeRating;

-(void)setupWithEpisode:(Episode*)episodeDetails;

@end
