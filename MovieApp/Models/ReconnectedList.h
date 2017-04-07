//
//  ReconnectedList.h
//  MovieApp
//
//  Created by Sakib Kurtic on 23/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RLReconectedList;

@interface ReconnectedList : NSObject

@property NSNumber *mediaID;
@property NSNumber *rate;
@property NSString *listName;
@property BOOL isMovie;
@property BOOL toSet;

-(id)initWithRL:(RLReconectedList*)rl;

@end
