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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    CGRect labelFrame = self.contentLabel.frame;
    labelFrame.size.height = self.frame.size.height - 55.0f;
    self.contentLabel.frame = labelFrame;
    
    CGRect buttonFrame = self.readMoreButton.frame;
    buttonFrame.origin.y = labelFrame.origin.y+labelFrame.size.height+10.0f;
    self.readMoreButton.frame = buttonFrame;
}

-(void) setupWithReview:(Review *) singleReview{
    _authorLabel.text=singleReview.author;
    _contentLabel.text=singleReview.text;
}

@end
