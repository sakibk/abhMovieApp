//
//  SingleReview.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@protocol SingleReviewCellDelegate <NSObject>

-(void)readMore;

@end

extern NSString *const singleReviewCellIdentifier;

@interface SingleReviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *readMoreButton;
@property (strong, nonatomic) id<SingleReviewCellDelegate> delegate;
@property BOOL isLayoutSubview;


-(void) setupWithReview:(Review *) singleReview;
@end
