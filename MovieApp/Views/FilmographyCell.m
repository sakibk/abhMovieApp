//
//  FilmographyCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "FilmographyCell.h"
#import "SingleFilmographyCell.h"
#import <RestKit/RestKit.h>
#import "ApiKey.h"
#import "ConnectivityTest.h"
#import "Actor.h"
#import <Realm/Realm.h>
#import "RLMActor.h"

NSString *const filmographyCellIdentifier=@"FilmographyCellIdentifier";

@implementation FilmographyCell{
    BOOL isConnected;
    RLMRealm *realm;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"SingleFilmographyCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:singleFilmographyCellIdentifier];
    isConnected = [ConnectivityTest isConnected];
    realm = [RLMRealm defaultRealm];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)getStoredCasts{
    RLMResults<RLMActor*> *acts = [RLMActor objectsWhere:@"actorID = %@",_actorID];
    RLMActor *act = acts.firstObject;
    if(act.casts!=nil){
        for(RLMCast *cst in act.casts)
            [_allCasts addObject:[[Cast alloc]initWithCast:cst]];
    }
    else{
        //connect to proceede
    }
}

-(void)setStoredCasts{
    RLMResults<RLMActor*> *acts = [RLMActor objectsWhere:@"actorID = %@",_actorID];
    RLMActor *act = acts.firstObject;
    if(act.casts==nil){
        for(Cast *cst in _allCasts){
            [act.casts addObject:[[RLMCast alloc]initWithCast:cst]];
        }
    }
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:act];
    [realm commitWriteTransaction];
}

-(void)getCasts{
    NSString *pathP =[NSString stringWithFormat:@"/3/person/%@/combined_credits",_actorID];
    
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
        [self setStoredCasts];
        [_collectionView reloadData];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"RestKit returned error: %@", error);
    }];
    
}

-(void)setupWithActor:(Actor *)singleActor{
    _actorID=singleActor.actorID;
    if(isConnected)
        [self getCasts];
    else
        [self getStoredCasts];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _allCasts != nil ? [_allCasts count] : 0;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SingleFilmographyCell *cell = (SingleFilmographyCell *)[collectionView dequeueReusableCellWithReuseIdentifier:singleFilmographyCellIdentifier forIndexPath:indexPath];
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
        [self.delegate MediaWithCast:_singleCast];
    }
    else{
        [self.delegate MediaWithCast:_singleCast];
    }
}
- (void)MediaWithCast:(Cast *)castForMedia{
    
}

@end
