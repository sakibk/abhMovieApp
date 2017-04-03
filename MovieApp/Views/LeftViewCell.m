//
//  LeftViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 16/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        self.textLabel.textColor = [UIColor whiteColor];
        
        // -----
        
        self.separatorView = [UIView new];
        self.separatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.4];
        [self addSubview:self.separatorView];
    }
    return self;
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
    
    CGRect newImageIconFrame=CGRectMake(self.textLabel.frame.size.width-44,self.textLabel.frame.origin.y+10 , self.textLabel.frame.size.height-20, self.textLabel.frame.size.height-20);
    self.imageIconNew.frame=newImageIconFrame;
    [self.imageIconNew setAlpha:0.0];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    self.textLabel.alpha = highlighted ? 0.5 : 1.0;
}

@end
