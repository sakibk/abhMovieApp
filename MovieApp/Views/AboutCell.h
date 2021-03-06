//
//  AboutCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Actor.h"

@protocol AboutCellDelegate <NSObject>

-(void)colideColapse;

@end

extern NSString *const aboutCellIdentifier;

@interface AboutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fullBiography;
@property (weak, nonatomic) IBOutlet UIButton *fullBioButton;

@property(strong, nonatomic) id<AboutCellDelegate> delegate;

-(void)setupWithActor:(Actor *)singleActor;

@end
