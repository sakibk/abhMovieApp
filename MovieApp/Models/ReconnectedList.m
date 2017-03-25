//
//  ReconnectedList.m
//  MovieApp
//
//  Created by Sakib Kurtic on 23/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ReconnectedList.h"
#import "RLReconectedList.h"

@implementation ReconnectedList

-(id)initWithRL:(RLReconectedList*)rl{
    self = [super init];
    self.mediaID=rl.mediaID;
    self.listName=rl.listName;
    self.isMovie=rl.isMovie;
    self.rate=rl.rate;
    self.toSet=rl.toSet;
    return self;
}
@end
