//
//  SearchCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 06/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResult.h"


extern NSString *const searchCellIdentifier;

@interface SearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;
@property (weak, nonatomic) IBOutlet UILabel *searchRating;

-(void)setSearchCell:(SearchResult *)singleResult;

@end
