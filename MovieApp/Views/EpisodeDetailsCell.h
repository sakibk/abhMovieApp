//
//  EpisodeDetailsCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 12/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

extern NSString *const episodeDetailsCellIdentifier;

@interface EpisodeDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *episodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *airDate;
@property (weak, nonatomic) IBOutlet UILabel *rating;

-(void)setEpisodeDetails:(Episode *)singleEpisode;

@end
