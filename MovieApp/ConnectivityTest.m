//
//  ConnectivityTest.m
//  MovieApp
//
//  Created by Sakib Kurtic on 14/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "ConnectivityTest.h"
#import <Reachability/Reachability.h>

@implementation ConnectivityTest

+(BOOL)isConnected{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    BOOL connetctivity=YES;
    if(remoteHostStatus == NotReachable)
    {
        connetctivity =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        connetctivity = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    {
        connetctivity = TRUE;
        
    }
    return connetctivity;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
