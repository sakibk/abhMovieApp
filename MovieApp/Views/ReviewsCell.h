//
//  ReviewsCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleReviewCell.h"
#import "Review.h"
#import "TVShow.h"
extern NSString *const reviewsCellIdentifier;

@interface ReviewsCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic) NSMutableArray<Review *> *allReviews;
@property(strong,nonatomic) Review *singleReview;

-(void) setupWithMovieID:(NSNumber *)singleMovieID;

@end
