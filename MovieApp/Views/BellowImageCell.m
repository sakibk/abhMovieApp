//
//  BellowImageTableViewCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 26/01/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "BellowImageCell.h"
#import "Genre.h"
#import <RestKit/RestKit.h>

NSString * const BellowImageCellIdentifier=@"bellowImageCellIdentifier";

@implementation BellowImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void) setupWithMovie:(Movie *)singleMovie{
    _duration.text = [NSString stringWithFormat:@"%@ min",singleMovie.runtime];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    _releaseDate.text = [dateFormatter stringFromDate:singleMovie.releaseDate];
    
    _genreString = [[NSMutableString alloc]init];
    
    for (Genre *str in singleMovie.genreSet ){
        [_genreString appendString:[str valueForKey:@"name"]];
        [_genreString appendString:@", "];
    }
    [_genreString deleteCharactersInRange:NSMakeRange([_genreString length]-2, 2)];
    _genres.text = _genreString;
    
    

}

@end
