//
//  Seats.m
//  MovieApp
//
//  Created by Sakib Kurtic on 31/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Seats.h"

@implementation Seats

-(id)initWithSnap:(NSDictionary*)snap andID:(int)seatID{
    self = [super init];
    
    self.seatID=[NSNumber numberWithInt:seatID];
    self.row= [snap valueForKey:@"row"];
    self.taken =[[snap valueForKey:@"taken"] boolValue];
    
    return self;
}

@end
