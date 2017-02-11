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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setRestkit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRestkit{
    
}


-(void)setupWithSeason:(Season*)seasonDetails{
    
}

@end
