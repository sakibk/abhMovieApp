//
//  OverviewTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "OverviewCell.h"

NSString * const OverviewCellIdentifier=@"overviewCellIdentifier";

@implementation OverviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setupWithMovie :(Movie*) singleMovie{
    _rating.text = [NSString stringWithFormat:@"%@",singleMovie.rating];
    _overview.text = singleMovie.overview;
}

@end
