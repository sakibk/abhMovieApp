//
//  OverviewLineCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 11/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "OverviewdLineCell.h"

NSString *const overviewLineCellIdentifier=@"OverviewLineCellIdentifier";

@implementation OverviewLineCell{
    
    NSString *wLink;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupActorBirth:(NSDate*)birthDate :(NSString*)birthPlace{
    CGRect newRect =CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleLabel.frame.size.width+20, _titleLabel.frame.size.height);
    if(birthDate!=nil){
        [_titleLabel setFrame:newRect];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        _titleLabel.text = [NSString stringWithFormat:@"Born"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd LLLL yyyy"];
        if ([birthPlace isEqualToString:@""] || birthPlace==nil)
            _contentLabel.text  = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:birthDate]];
        else{
            _contentLabel.text  = [NSString stringWithFormat:@"%@, %@",[dateFormatter stringFromDate:birthDate],birthPlace];
        }
    }
    else if ([birthPlace isEqualToString:@""] || birthPlace==nil ){
        _titleLabel.text = @"";
        _contentLabel.text  = @"";
    }
    else{
        [_titleLabel setFrame:newRect];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        _titleLabel.text = [NSString stringWithFormat:@"Born"];
        _contentLabel.text  = [NSString stringWithFormat:@"%@",birthPlace];
    }
}

-(void)setupActorLink:(NSString*)link{
    if ([link isEqualToString:@""] || link==nil) {
        _titleLabel.text=@"";
        _contentLabel.text=@"";
    }
    else{
        CGRect newRect =CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y, _titleLabel.frame.size.width+20, _titleLabel.frame.size.height);
        [_titleLabel setFrame:newRect];
        [_titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        _titleLabel.text = [NSString stringWithFormat:@"Website"];
        [_contentLabel setAlpha:0.0];
        UIColor *blColor = [UIColor colorWithRed:0.29 green:0.56 blue:0.89 alpha:1.0];
        UIButton *websiteLink = [[UIButton alloc]initWithFrame:_contentLabel.frame];
        [websiteLink.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [websiteLink setTitleColor:blColor forState:UIControlStateNormal];
        [websiteLink setTitle:link forState:UIControlStateNormal];
        wLink=link;
        [websiteLink addTarget:self action:@selector(openWebsite:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:websiteLink];
    }
}

-(IBAction)openWebsite:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:wLink]];
}

@end
