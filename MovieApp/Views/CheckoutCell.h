//
//  CheckoutCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 04/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const checkoutCellIdentifier;

@interface CheckoutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *checkoutInfo;

-(void)setupWithString:(NSString*)cellTitle andAtributedPart:(NSString*)cellText;
-(void)setupWithTitle:(NSString*)titleString;
-(void)setupWithDate:(NSString*)dateString;
@end
