//
//  SeasonsCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 01/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "SeasonsCell.h"
#import <RestKit/RestKit.h>

NSString *const seasonsCellIdentifier=@"SeasonsCellIdentifier";

@implementation SeasonsCell

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

    NSString *pathP =[NSString stringWithFormat:@"/3/tv/%@",singleShow.showID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": @"893050c58b2e2dfe6fa9f3fae12eaf64"/*add your api*/
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
                
                [self setupSeasons];
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];

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
