//
//  AboveImageCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const aboveImageCellIdentifier;

@interface AboveImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleString;

-(void)setupTitleWithString:(NSString* )stringForTitle;
@end
