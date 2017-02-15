//
//  ImageCell.h
//  MovieApp
//
//  Created by Sakib Kurtic on 14/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const imageCellIdentifier;

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;

-(void)setupWithUrl:(NSString*) posterPath;

@end
