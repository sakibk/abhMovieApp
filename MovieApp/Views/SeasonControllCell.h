//
//  SeasonControllCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 11/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const seasonControllCellIdentifier;

@interface SeasonControllCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *seasonNumber;

-(void)setupSeasonCellWithSeasonNumber:(NSNumber *)seasonNo;
-(void)setupWhiteColor;
-(void)setupYellowColor;

@end
