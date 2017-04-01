//
//  Seats.h
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Seats : NSObject

@property (strong, nonatomic) NSNumber *seatID;
@property (strong, nonatomic) NSString *row;
@property (strong, nonatomic) NSNumber *seatNum;
@property BOOL taken;

@end
