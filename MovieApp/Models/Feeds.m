//
//  Feeds.m
//  MovieApp
//
//  Created by Sakib Kurtic on 23/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "Feeds.h"

@implementation Feeds

- (NSString *)description
{
    return [NSString stringWithFormat:@"Title: %@, Link: %@, Text: %@",self.title,self.link,self.desc];
}

@end
