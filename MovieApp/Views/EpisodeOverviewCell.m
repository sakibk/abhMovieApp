//
//  EpisodeOverviewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 12/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "EpisodeOverviewCell.h"

NSString *const episodeOverviewCellIdentifier=@"EpisodeOverviewCellIdentifier";

@implementation EpisodeOverviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupOverviewWithText:(NSString*)overview{
    _overviewLabel.text=overview;
}

@end
