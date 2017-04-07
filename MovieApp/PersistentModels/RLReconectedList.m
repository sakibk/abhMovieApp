//
//  RLReconectedList.m
//  MovieApp
//
//  Created by Sakib Kurtic on 23/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "RLReconectedList.h"


@implementation RLReconectedList

-(id)initWithRL:(ReconnectedList*)rl{
    self = [super init];
    self.mediaID=rl.mediaID;
    self.listName=rl.listName;
    self.isMovie=rl.isMovie;
    self.rate=rl.rate;
    self.toSet=rl.toSet;
    return self;
}

@end
