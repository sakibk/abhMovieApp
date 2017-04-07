//
//  CastCollectionCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 27/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"
#import "Cast.h"
#import <RestKit/RestKit.h>
#import "Episode.h"

@protocol CastCollectionCellDelegate <NSObject>

- (void)openActorWithID:(NSNumber *)actorID;

@end

extern NSString *const castCollectionCellIdentifier;

@interface CastCollectionCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) id<CastCollectionCellDelegate> delegate;

-(void) setupWithMovie:(Movie *)singleMovie;
-(void) setupWithShow:(TVShow *)singleShow;
-(void) setupWithEpisode:(Episode *)singleEpisode;

@property NSMutableArray<Cast *> *allCasts;
@property Cast *singleCast;
@property NSString *movieID;
@property BOOL isConnected;

@end
