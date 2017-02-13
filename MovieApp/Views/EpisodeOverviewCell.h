//
//  EpisodeOverviewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 12/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const episodeOverviewCellIdentifier;

@interface EpisodeOverviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

-(void)setupOverviewWithText:(NSString*)overview;
@end
