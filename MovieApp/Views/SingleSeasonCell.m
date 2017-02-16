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
    NSNumberFormatter *formatter;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //initialization code
    [self setFormater];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFormater{
    formatter = [[NSNumberFormatter alloc] init];
    
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:1];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
}

-(void)setupWithEpisode:(Episode*)episodeDetails{
    NSString * rate = [self setRating:episodeDetails.rating];
    _episodeRating.text=[NSString stringWithFormat:@"%@%@",_episodeRating.text,rate];
    _episodeTitle.text =[NSString stringWithFormat:@"%@. %@",episodeDetails.episodeNumber,episodeDetails.episodeName];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    _episodeRealeaseDate.text = [dateFormatter stringFromDate:episodeDetails.airDate];
}

-(NSString *)setRating:(NSNumber*)rate{
    
    return [formatter stringFromNumber:rate];
    
    
}

@end
