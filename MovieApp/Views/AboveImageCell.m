//
//  AboveImageCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "AboveImageCell.h"

NSString *const aboveImageCellIdentifier=@"AboveImageCellIdentifier";

@implementation AboveImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupTitleWithString:(NSString* )stringForTitle{
    _titleString.text = stringForTitle;
}

@end
