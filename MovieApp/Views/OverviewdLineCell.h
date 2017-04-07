//
//  OverviewLineCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 11/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const overviewLineCellIdentifier;

@interface OverviewLineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


-(void)setupActorBirth:(NSDate*)birthDate :(NSString*)birthPlace;
-(void)setupActorLink:(NSString*)link;
@end
