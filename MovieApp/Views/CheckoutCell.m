//
//  CheckoutCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 04/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "CheckoutCell.h"

NSString *const checkoutCellIdentifier=@"CheckoutCellIdentifier";

@implementation CheckoutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithString:(NSString*)cellTitle andAtributedPart:(NSString*)cellText{
    NSMutableAttributedString *atributedTitle =
    [[NSMutableAttributedString alloc]
     initWithString:[NSString stringWithFormat:@"    %@: %@",cellTitle,cellText]];
    [atributedTitle addAttribute:NSForegroundColorAttributeName
                 value:[UIColor lightGrayColor]
                 range:NSMakeRange(0, [cellTitle length]+5)];
    [atributedTitle addAttribute:NSForegroundColorAttributeName
                 value:[UIColor colorWithRed:0.97 green:0.70 blue:0.0 alpha:1.0]
                 range:NSMakeRange([cellTitle length]+5, [cellText length]+1)];
    [_checkoutInfo setFont:[UIFont systemFontOfSize:18.0]];
    [_checkoutInfo setAttributedText:atributedTitle];
}

-(void)setupWithTitle:(NSString*)titleString{
    [_checkoutInfo setFont:[UIFont boldSystemFontOfSize:20.0]];
    [_checkoutInfo setTextColor:[UIColor whiteColor]];
    [_checkoutInfo setText:[NSString stringWithFormat:@"    %@", titleString]];
}

-(void)setupWithDate:(NSString*)dateString{
    [_checkoutInfo setFont:[UIFont systemFontOfSize:18.0]];
    [_checkoutInfo setTextColor:[UIColor lightGrayColor]];
    [_checkoutInfo setText:[NSString stringWithFormat:@"    %@", dateString]];
}

@end
