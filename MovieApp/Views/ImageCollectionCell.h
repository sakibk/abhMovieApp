//
//  ImageCollectionTableViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
#import "TVShow.h"

@protocol ImageCollectionCellDelegate <NSObject>

-(void)openImageGallery;

@end

extern NSString * const ImageCollectionCellIdentifier;

@interface ImageCollectionCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id<ImageCollectionCellDelegate> delegate;


-(void)setupWithMovie:(Movie *)singleMovie;
-(void)setupWithShow:(TVShow *)singleShow;

@end
