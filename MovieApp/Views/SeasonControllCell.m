//
//  SeasonControllCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SeasonControllCell.h"

NSString *const seasonControllCellIdentifier=@"SeasonControllCellIdentifier";

@implementation SeasonControllCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setupSeasonCellWithSeasonNumber:(NSNumber *)seasonNo{
    _seasonNumber.text=[NSString stringWithFormat:@"%@",seasonNo];
}

-(void)setupWhiteColor{
    [_seasonNumber setTextColor:[UIColor whiteColor]];
}

-(void)setupYellowColor{
    [_seasonNumber setTextColor:[UIColor colorWithRed:0.97 green:0.79 blue:0.0 alpha:1.0]];
}
@end
