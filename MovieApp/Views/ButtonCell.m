//
//  ButtonCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ButtonCell.h"

NSString *const buttonCellIdentifier = @"ButtonCellIdentifier";

@implementation ButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _button.layer.cornerRadius=3;
    [_button addTarget:self action:@selector(pushBookingView) forControlEvents:UIControlEventTouchUpInside];
}

-(void)pushBookingView{
    [self.delegate pushBookingView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
