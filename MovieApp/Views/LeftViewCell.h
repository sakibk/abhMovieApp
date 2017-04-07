//
//  LeftViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftViewCell : UITableViewCell


@property (strong, nonatomic) UIView *separatorView;
@property (strong, nonatomic) UIImageView *imageIcon;
@property (strong, nonatomic) UIImageView *imageIconNew;

-(void)setupNewButton;

@end
