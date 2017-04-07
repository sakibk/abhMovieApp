//
//  SingleSeasonCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SingleSeasonCell.h"
#import <RestKit/RestKit.h>

NSString *const singleSeasonCellIdentifier=@"SingleSeasonCellIdentifier";

@implementation SingleSeasonCell
{
    NSStringTransform formatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithEpisode:(Episode*)episodeDetails{
    _episodeRating.text=[[NSString stringWithFormat:@"%@  ",episodeDetails.rating] substringWithRange:NSMakeRange(0, 3)];
    _episodeTitle.text =[NSString stringWithFormat:@"%@. %@",episodeDetails.episodeNumber,episodeDetails.episodeName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    _episodeRealeaseDate.text = [dateFormatter stringFromDate:episodeDetails.airDate];
}

@end
