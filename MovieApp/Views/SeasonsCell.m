//
//  SeasonsCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 01/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SeasonsCell.h"
#import <RestKit/RestKit.h>
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import <Realm/Realm.h>
#import "RLTVShow.h"
#import "RLMSeason.h"

NSString *const seasonsCellIdentifier=@"SeasonsCellIdentifier";

@implementation SeasonsCell{
    BOOL isConnected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_seeAllButton addTarget:self action:@selector(seeSeasons:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void) setupWithShowID:(TVShow *)singleShow{
    isConnected = [ConnectivityTest isConnected];
    if(isConnected)
        [self getSeasonsNet:singleShow];
    else
        [self getStoredSeasons:singleShow];

}

-(void)getSeasonsNet:(TVShow*)singleShow{
    
    NSString *pathP =[NSString stringWithFormat:@"/3/tv/%@",singleShow.showID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        singleShow.seasons=[[NSMutableArray alloc]initWithArray:mappingResult.array];
        
        
        _singleShow = [[TVShow alloc]init];
        singleShow.seasons=[[NSMutableArray alloc]init];
        for (Season *oneSeason in mappingResult.array) {
            if ([oneSeason isKindOfClass:[Season class]]) {
                [singleShow.seasons addObject:oneSeason];
            }
        }
        _singleShow=singleShow;
        [self setStoredSeasons];
        [self setupSeasons];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

-(void)getStoredSeasons:(TVShow*)singleShow{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",_singleShow.showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.seasons.firstObject!= nil){
        
    }
}

-(void)setStoredSeasons{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",_singleShow.showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.seasons.firstObject!= nil){
        
    }
    else{
        //please reconnect 
    }
}

-(void)setupSeasons{
    _allYearsString=[[NSMutableString alloc]init];
    _allSeasonString=[[NSMutableString alloc]init];
    int i;
    for(i= [_singleShow.seasonCount intValue]-1; i>=0; i--){
        Season *oneSeason  = [_singleShow.seasons objectAtIndex:i];
        NSDate *releaseYear = oneSeason.airDate;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:releaseYear];
        NSNumber *year =[NSNumber numberWithInteger:[components year]];
        [_allYearsString appendString:[NSString stringWithFormat:@"%@ ",year]];
        [_allSeasonString appendString:[NSString stringWithFormat:@"%@ ",oneSeason.seasonNumber]];
    }
    _seasons.text = _allSeasonString;
    _releaseYears.text = _allYearsString;
}

-(IBAction)seeSeasons:(id)sender{
    [_delegate allSeasonsView];
}

-(void)allSeasonsView{
    
}

@end
