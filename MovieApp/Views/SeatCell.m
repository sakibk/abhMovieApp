//
//  SeatCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SeatCell.h"
NSString *const seatCellIdentifier=@"SeatC";
@implementation SeatCell

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setYellowCircle{
    [_circleImage setImage:[UIImage imageNamed:@"YellowCircle"]];
}

-(void)setLightCircle{
    [_circleImage setImage:[UIImage imageNamed:@"LightCircle"]];
}

-(void)setDarkCircle{
    [_circleImage setImage:[UIImage imageNamed:@"DarkCircle"]];
}

-(void)setupSeatCell:(Seats*)seat{
    _seat=seat;
    if(seat.taken)
        [self setDarkCircle];
    else
        [self setLightCircle];
}
-(void)setupNonSeatCell{
    [_circleImage setImage:[UIImage imageNamed:@""]];
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
