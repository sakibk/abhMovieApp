//
//  EpisodeDetailsCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 12/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "EpisodeDetailsCell.h"

NSString *const episodeDetailsCellIdentifier=@"EpisodeDetailsCellIdentifier";

@implementation EpisodeDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setEpisodeDetails:(Episode *)singleEpisode{
    
    _episodeTitle.text = [NSString stringWithFormat:@"%@",singleEpisode.episodeName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];

    _airDate.text=[dateFormatter stringFromDate:singleEpisode.airDate];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    
    NSString *numberString = [formatter stringFromNumber:singleEpisode.rating];
    
    _rating.text=[NSString stringWithFormat:@"%@%@",numberString,@"/10"];
}


@end
