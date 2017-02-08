//
//  Actor.h
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Actor : NSObject

@property(strong,nonatomic) NSNumber *actorID;
@property(strong,nonatomic) NSNumber *gender;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSArray<NSString*> *nickNames;
@property(strong,nonatomic) NSDate *birthDate;
@property(strong,nonatomic) NSDate *deathDate;
@property(strong,nonatomic) NSString *birthPlace;
@property(strong,nonatomic) NSString *homePage;
@property(strong,nonatomic) NSString *biography;
@property(strong,nonatomic) NSString *profilePath;

@end
