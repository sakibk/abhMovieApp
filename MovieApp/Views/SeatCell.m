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
    _isSelected=NO;
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
    _seat =[[Seats alloc]init];
    _seat=seat;
    if([seat taken]){
        [self setDarkCircle];
    }else{
        [self setLightCircle];
    }
}

-(void)setupSelected{
    if(![_seat taken]){
    if(_isSelected){
        [self setLightCircle];
        [self.delegate popSelectedSeat:_seat];
        _isSelected=NO;
    }else{
        [self setYellowCircle];
        [self.delegate pushSelectedSeat:_seat];
        _isSelected=YES;
    }
    }
}


-(void)setupNonSeatCell{
    [_circleImage setImage:[UIImage imageNamed:@""]];
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
