//
//  LeftViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

-(void)setupNewButton{
    _imageIconNew =[[UIImageView alloc]init];
    CGRect newImageIconFrame=CGRectMake(self.frame.size.width-167, 15, self.frame.size.height-20, self.frame.size.height-20);
    [_imageIconNew setFrame:newImageIconFrame];
    [self.imageIconNew setImage:[UIImage imageNamed:@"CinemaNew"]];
    [self.imageIconNew sizeToFit];
    [self addSubview:self.imageIconNew];
    [self.imageIconNew setAlpha:1.0];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect imageIconFrame=CGRectMake(24,self.textLabel.frame.origin.y+10 , self.textLabel.frame.size.height-20, self.textLabel.frame.size.height-20);
    
    self.imageView.frame=imageIconFrame;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x = 12+self.textLabel.frame.origin.x;
    textLabelFrame.size.width = CGRectGetWidth(self.frame) - 16.0;
    self.textLabel.frame = textLabelFrame;
    
    CGFloat height = UIScreen.mainScreen.scale == 1.0 ? 1.0 : 0.5;
    
    self.separatorView.frame = CGRectMake(0.0,
                                          CGRectGetHeight(self.frame)-height,
                                          CGRectGetWidth(self.frame)*0.9,
                                          height);
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
