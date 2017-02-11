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
@end
