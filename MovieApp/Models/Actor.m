//
//  Actor.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Actor.h"
#import "RLMActor.h"

@implementation Actor

-(id)initWithActor:(RLMActor*)actor{
    self = [super init];
    self.name=actor.name;
    self.nickNames = [[NSArray alloc] initWithObjects:actor.nickName, nil];
    self.biography = actor.biography;
    self.birthDate = actor.birthDate;
    self.birthPlace = actor.birthPlace;
    self.actorID = actor.actorID;
    self.profilePath = actor.profilePath;
    self.deathDate = actor.deathDate;
    self.gender = actor.gender;
    self.homePage = actor.homePage;
    return self;
}

// Here you need to add all Movie properties that needs to be mapped.
+ (NSDictionary*)elementToPropertyMappings {
    
    NSDictionary *dict = @{@"name": @"name",
                           @"also_known_as": @"nickNames",
                           @"biography": @"biography",
                           @"birthday": @"birthDate",
                           @"id": @"actorID",
                           @"profile_path" : @"profilePath",
                           @"deathday":@"deathDate",
                           @"place_of_birth": @"birthPlace",
                           @"gender" : @"gender",
                           @"homepage":@"homePage"
                           };
    return dict;
}

+(RKObjectMapping*)responseMapping {
    // Create an object mapping.
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Actor class]];
    [mapping addAttributeMappingsFromDictionary:[self elementToPropertyMappings]];
    mapping.assignsDefaultValueForMissingAttributes = NO;
    
    return mapping;
}

// Here you need to add paths for every method.
+(NSString*)pathPatternForRequestMethod:(RKRequestMethod)method{
    NSString *path;
    switch (method) {
        case RKRequestMethodGET:
            path = @"/3/person/:id";
            break;
        default:
            break;
    }
    return path;
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalResponseDescriptors{
    return @[
             ];
    
}

// Here you add additional response descriptors if you need them.
// e.g. If you need to map again Movie model from another path with GET method.
+ (NSArray *)additionalRequestDescriptors{
    return nil;
    
}

@end
