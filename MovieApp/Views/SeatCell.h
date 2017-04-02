//
//  SeatCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Seats.h"

extern NSString *const seatCellIdentifier;
@interface SeatCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *circleImage;
@property BOOL isSelected;
@property (strong,nonatomic) Seats* seat;

-(void)setupNonSeatCell;
-(void)setupSeatCell:(Seats*)seat;
-(void)setYellowCircle;
-(void)setLightCircle;
-(void)setDarkCircle;

@end
