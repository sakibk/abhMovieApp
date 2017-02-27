//
//  SingleReview.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SingleReviewCell.h"

NSString *const singleReviewCellIdentifier = @"SingleReviewCellIdentifier";

@implementation SingleReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_readMoreButton addTarget:self action:@selector(readButton:) forControlEvents:UIControlEventTouchUpInside];
    [_readMoreButton setTitle:@"Read more" forState:UIControlStateNormal];
    _isLayoutSubview=NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    if(!_isLayoutSubview){
    CGRect labelFrame = self.contentLabel.frame;
    labelFrame.size.height = self.frame.size.height - 55.0f;
    self.contentLabel.frame = labelFrame;
    
    CGRect buttonFrame = self.readMoreButton.frame;
    buttonFrame.origin.y = labelFrame.origin.y+labelFrame.size.height+10.0f;
    self.readMoreButton.frame = buttonFrame;
        _isLayoutSubview=YES;
    }
}

-(void) setupWithReview:(Review *) singleReview{
    _authorLabel.text=singleReview.author;
    _contentLabel.text=singleReview.text;
}

-(IBAction)readButton:(id)sender{
    [self.delegate readMore];
}

-(void)readMore{
    if([_readMoreButton.currentTitle isEqualToString:@"Read more"]){
        [_readMoreButton setTitle:@"Read less" forState:UIControlStateNormal];
    }
    else{
        [_readMoreButton setTitle:@"Read more" forState:UIControlStateNormal];
    }
}

@end
