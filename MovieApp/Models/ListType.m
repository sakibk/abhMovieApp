//
//  ListType.m
//  MovieApp
//
//  Created by Sakib Kurtic on 20/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ListType.h"
#import "RLMListType.h"

@implementation ListType

-(id)initWithRLMListType:(RLMListType*)type{
    self=[super init];
    self.listTypeID=type.listTypeID;
    self.name=type.name;
    return self;
}

-(id)initWithValues:(NSString*)typeName and:(NSNumber*)typeID{
    self=[super init];
    self.listTypeID=typeID;
    self.name=typeName;
    return self;
}

@end
