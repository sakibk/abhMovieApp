//
//  RKObjectManager+SharedInstances.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <RestKit/RestKit.h>

@interface RKObjectManager (SharedInstances)
+(instancetype) boxOfficeManager;
@end
