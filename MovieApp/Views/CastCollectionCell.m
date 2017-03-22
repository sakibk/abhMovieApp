//
//  CastCollectionCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "CastCollectionCell.h"
#import "SingleCastCell.h"
#import "ActorDetailsViewController.h"
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import "RLMStoredObjects.h"
#import "RLMActor.h"
#import "RLMovie.h"
#import "RLTVShow.h"
#import "RLMEpisode.h"
#import "RLMCast.h"
#import "RLMSeason.h"
#import <Realm/Realm.h>

NSString *const castCollectionCellIdentifier=@"CastCollectionCellIdentifier";


@implementation CastCollectionCell{
    RLMRealm *realm;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _isConnected = [ConnectivityTest isConnected];
    realm = [RLMRealm defaultRealm];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SingleCastCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:singleCastCellIdentifier];
}



-(void) setupWithMovie:(Movie *)singleMovie{
    if(_isConnected)
        [self getMovieCasts:singleMovie];
    else
        [self getStoredMovieCasts:singleMovie];
}

-(void)getStoredMovieCasts:(Movie *)singleMovie{
    RLMResults<RLMovie*> *mvs = [RLMovie objectsWhere:@"movieID = %@",singleMovie.movieID];
    RLMovie *mv = mvs.firstObject;
    if(mv.movieCast.firstObject!=nil){
        for(RLMCast *cst in mv.movieCast)
            [_allCasts addObject:[[Cast alloc]initWithCast:cst]];
    }
    else{
        //connect to proceede
    }
}

-(void)setStoredMovieCasts:(NSNumber*)movieID{
    RLMResults<RLMovie*> *mvs = [RLMovie objectsWhere:@"movieID = %@",movieID];
    RLMovie *mv = mvs.firstObject;
    if(mv.movieCast.firstObject==nil){
        [realm beginWriteTransaction];
        for(Cast *cst in _allCasts){
            [mv.movieCast addObject:[[RLMCast alloc]initWithCast:cst]];
        }
        [realm addOrUpdateObject:mv];
        [realm commitWriteTransaction];
    }
}

-(void)getMovieCasts:(Movie*)singleMovie{
    NSString *pathP =[NSString stringWithFormat:@"/3/movie/%@/credits",singleMovie.movieID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
        _allCasts = [[NSMutableArray alloc] init];
        for (Cast *cast in mappingResult.array) {
            if ([cast isKindOfClass:[Cast class]]) {
                [_allCasts addObject:cast];
            }
        }
        [self setStoredMovieCasts:singleMovie.movieID];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

-(void) setupWithShow:(TVShow *)singleShow{
    if(_isConnected)
        [self getShowCasts:singleShow];
    else
        [self getStoredShowCasts:singleShow];
}

-(void)getStoredShowCasts:(TVShow *)singleShow{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",singleShow.showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.showCast.firstObject!=nil){
        for(RLMCast *cst in tv.showCast)
            [_allCasts addObject:[[Cast alloc]initWithCast:cst]];
    }
    else{
        //connect to proceede
    }
}

-(void)setStoredShowCasts:(NSNumber*)showID{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.showCast.firstObject==nil){
        [realm beginWriteTransaction];
        for(Cast *cst in _allCasts)
            [tv.showCast addObject:[[RLMCast alloc]initWithCast:cst]];
        [realm addOrUpdateObject:tv];
        [realm commitWriteTransaction];
    }
}

-(void)getShowCasts:(TVShow*)singleShow{
    
    NSString *pathP =[NSString stringWithFormat:@"/3/tv/%@/credits",singleShow.showID];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
        _allCasts = [[NSMutableArray alloc] init];
        for (Cast *cast in mappingResult.array) {
            if ([cast isKindOfClass:[Cast class]]) {
                [_allCasts addObject:cast];
            }
        }
        [self setStoredShowCasts:singleShow.showID];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

-(void) setupWithEpisode:(Episode *)singleEpisode{
    if(_isConnected)
        [self getEpisodeCasts:singleEpisode];
    else
        [self getStoredEpisodeCasts:singleEpisode];
}

-(void)getStoredEpisodeCasts:(Episode *)singleEpisode{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",singleEpisode.showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.seasons.firstObject!= nil){
        RLMSeason *selectedSeason = [tv.seasons objectAtIndex:[singleEpisode.seasonNumber integerValue]];
        if(selectedSeason.episodes.firstObject.episodeCasts.firstObject!=nil){
            RLMEpisode *ep = [selectedSeason.episodes objectAtIndex:[singleEpisode.episodeNumber integerValue]];
            for(RLMCast *cst in ep.episodeCasts)
                [_allCasts addObject:[[Cast alloc]initWithCast:cst]];
        }
        else{
            //connect to proceede
        }
    }
    else{
        //connect to proceede
    }
}

-(void)setStoredEpisodeCasts:(NSNumber*)showID and:(NSNumber*)seasonNumber and:(NSNumber*)episodeNumber{
    RLMResults<RLTVShow*> *tvs = [RLTVShow objectsWhere:@"showID = %@",showID];
    RLTVShow *tv = tvs.firstObject;
    if(tv.seasons.firstObject!= nil){
        RLMSeason *selectedSeason = [tv.seasons objectAtIndex:[seasonNumber integerValue]];
        if(selectedSeason.episodes.firstObject.episodeCasts.firstObject!=nil){
            RLMEpisode *ep = [selectedSeason.episodes objectAtIndex:[episodeNumber integerValue]];
            if(ep.episodeCasts.firstObject == nil){
                [realm beginWriteTransaction];
                for(Cast *cst in _allCasts)
                    [ep.episodeCasts addObject:[[RLMCast alloc]initWithCast:cst]];
                [realm addOrUpdateObject:ep];
                [realm commitWriteTransaction];
            }
        }
        
    }
}


-(void)getEpisodeCasts:(Episode *)singleEpisode{
    NSString *pathP =[NSString stringWithFormat:@"/3/tv/%@/season/%@/episode/%@/credits",singleEpisode.showID,singleEpisode.seasonNumber,singleEpisode.episodeNumber];
    
    NSDictionary *queryParameters = @{
                                      @"api_key": [ApiKey getApiKey]/*add your api*/
                                      };
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathP parameters:queryParameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"%@", mappingResult.array);
        
        _allCasts = [[NSMutableArray alloc] init];
        for (Cast *cast in mappingResult.array) {
            if ([cast isKindOfClass:[Cast class]]) {
                [_allCasts addObject:cast];
            }
        }
        [self setStoredEpisodeCasts:singleEpisode.showID and:singleEpisode.seasonNumber and:singleEpisode.episodeNumber];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allCasts != nil ? [_allCasts count] : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleCastCell *cell = (SingleCastCell *)[collectionView dequeueReusableCellWithReuseIdentifier:singleCastCellIdentifier forIndexPath:indexPath];
    _singleCast=[_allCasts objectAtIndex:indexPath.row];
    
    [cell setupWithCast:_singleCast];
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return CGSizeMake(160.0, 293.0);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _singleCast = [_allCasts objectAtIndex:indexPath.row];
    if(_singleCast.castWithID!=nil) {
        [_delegate openActorWithID:_singleCast.castWithID];
    }
    else{
        [_delegate openActorWithID:_singleCast.castID];
    }
}
//
//- (IBAction)actorCellTapped:(id)sender
//{
//    if ([_delegate respondsToSelector:@selector(actorTappedInCell:)])
//    {
//        [_delegate performSelector:@selector(actorTappedInCell:) withObject:self];
//    }
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"ActorDetails"]) {
        ActorDetailsViewController *actorDetails = segue.destinationViewController;
        NSIndexPath *indexPath = [self.collectionView.indexPathsForSelectedItems objectAtIndex:0];
        _singleCast = [_allCasts objectAtIndex:indexPath.row];
        actorDetails.actorID=_singleCast.castID;
        [actorDetails searchForActor];
    }
}


@end

