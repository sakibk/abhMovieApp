//
//  ListType.h
//  MovieApp
//
//  Created by Sakib Kurtic on 20/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RLMListType;

@interface ListType : NSObject

@property (nonatomic, strong) NSNumber *listTypeID;
@property (nonatomic, strong) NSString  *name;

-(id)initWithRLMListType:(RLMListType*)type;
-(id)initWithValues:(NSString*)typeName and:(NSNumber*)typeID;

@end
