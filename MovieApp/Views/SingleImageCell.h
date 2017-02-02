//
//  SingleImageCollectionViewCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const SingleImageCellIdentifier;

@interface SingleImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

-(void)setupWithUrl:(NSString*) posterPath;

@end
