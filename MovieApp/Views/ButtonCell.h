//
//  ButtonCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const buttonCellIdentifier;

@protocol ButtonCellProtocol <NSObject>

-(void)pushBookingView;

@end

@interface ButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) id<ButtonCellProtocol> delegate;

@end
