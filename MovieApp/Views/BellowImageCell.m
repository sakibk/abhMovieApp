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
    int mins = [singleMovie.runtime intValue] %60;
    int hours = [singleMovie.runtime intValue] /60;
    if(hours==0){
    _duration.text = [NSString stringWithFormat:@"%@ min",singleMovie.runtime];
    }
    else if(mins==0){
        _duration.text = [NSString stringWithFormat:@"%d h",hours];
    }
    else
    {
        _duration.text = [NSString stringWithFormat:@"%dh %dmin",hours,mins];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd LLLL yyyy"];
    
    _releaseDate.text = [dateFormatter stringFromDate:singleMovie.releaseDate];
    
    _genreString = [[NSMutableString alloc]init];
    
    for (Genre *str in singleMovie.genreSet ){
        [_genreString appendString:[str valueForKey:@"name"]];
        [_genreString appendString:@", "];
    }
    if([_genreString length]>3){
        [_genreString deleteCharactersInRange:NSMakeRange([_genreString length]-2, 2)];
    }
    else{
        [_genreString appendString:@"Genres not avalible"];
    }
    _genres.text = _genreString;

}

-(void) setupWithShow:(TVShow *)singleShow{
    if([singleShow.runtime count]>=2){
    _duration.text = [NSString stringWithFormat:@"%@-%@ min",[singleShow.runtime objectAtIndex:0],[singleShow.runtime objectAtIndex:1]];
    }
    else if ([singleShow.runtime count] == 1){
        if([singleShow.runtime objectAtIndex:0]!=nil || [singleShow.runtime objectAtIndex:0]!=0)
            _duration.text = [NSString stringWithFormat:@"%@ min",[singleShow.runtime objectAtIndex:0]];
        else
            _duration.text = [NSString stringWithFormat:@"Runtime not avalible"];
    }
    else{
        _duration.text = [NSString stringWithFormat:@"Runtime not avalible"];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    
    _releaseDate.text =[NSString stringWithFormat:@"TV Series (%@-)",[dateFormatter stringFromDate:singleShow.firstAirDate]];
    
    _genreString = [[NSMutableString alloc]init];
    
    for (Genre *str in singleShow.genreSet ){
        [_genreString appendString:[str valueForKey:@"name"]];
        [_genreString appendString:@", "];
    }
    if([_genreString length]>3){
        [_genreString deleteCharactersInRange:NSMakeRange([_genreString length]-2, 2)];
    }
    else{
        [_genreString appendString:@"Genres not avalible"];
    }
    _genres.text = _genreString;
    
}

@end
