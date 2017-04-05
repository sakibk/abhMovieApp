//
//  PickerCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "PickerCell.h"
#import "Hours.h"
#import  <QuartzCore/QuartzCore.h>

NSString *const pickerCellIdentifier=@"PickerCellIdentifier";

@implementation PickerCell
{
    BOOL areHours;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    [_pickerView setShowsSelectionIndicator:YES];
        [_pickerButton addTarget:self action:@selector(popPicker:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)popPicker:(id)sender{
    [_pickerButton setAlpha:0.0];
    [_imageDown setAlpha:0.0];
    [self.delegate popPicker:sender];
    [self.delegateOne popMoviePicker:sender];
}

-(void)setButonEdges{

    [[_pickerButton layer] setBorderWidth:1.0f];
    [[_pickerButton layer] setCornerRadius:4.0f];
    [[_pickerButton layer] setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    NSArray *constraints = @[
                             [_pickerButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
                             [_pickerButton.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10],
                             [_pickerView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-10],
                             [_pickerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10]
                             ];
    
    [NSLayoutConstraint activateConstraints:constraints];
    
}

-(void)setupWithHours:(NSMutableArray<Hours*>*) playingHours{
    _hoursPlaying =[[NSMutableArray alloc]initWithArray:playingHours];
    areHours=YES;
}

-(void)setupWithPlayingMovies:(NSMutableArray<Movie*>*)playingMovies andSelectedMovie:(Movie*)selectedMovie{
    _playingMovies=[[NSMutableArray alloc]initWithArray:playingMovies];
    _selectedMovie=selectedMovie;
    areHours=NO;
    [_pickerButton setTitle:selectedMovie.title forState:UIControlStateNormal];
    [_imageDown setImage:[UIImage imageNamed:@"DropDownYellow"]];
    [_pickerButton setBackgroundColor:[UIColor blackColor]];
    [_pickerView reloadAllComponents];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if(areHours)
        return [_hoursPlaying count];
    else
        return [_playingMovies count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(areHours)
        return [NSString stringWithFormat:@"%@",[[_hoursPlaying objectAtIndex:row] playingHour]];
    else
        return [NSString stringWithFormat:@"%@",[[_playingMovies objectAtIndex:row] title]];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    if(areHours){
    NSLog(@"Selected Tearm: %@. Index of selected term: %ld", [[_hoursPlaying objectAtIndex:row] playingHour], (long)row);
        [_pickerButton setTitle:[[_hoursPlaying objectAtIndex:row] playingHour] forState:UIControlStateNormal];
    [self.delegate pushHoursTroughDelegate:[_hoursPlaying objectAtIndex:row]];
    [self.delegate popPicker:_pickerButton];
    }
    else{
        NSLog(@"Selected Tearm: %@. Index of selected term: %ld", [[_playingMovies objectAtIndex:row] title], (long)row);
        [self.delegateOne pushMoviesTroughDelegate:[_playingMovies objectAtIndex:row]];
        [_pickerButton setTitle:[[_playingMovies objectAtIndex:row] title] forState:UIControlStateNormal];
    [self.delegateOne popMoviePicker:_pickerButton];
    }
    [_pickerButton setAlpha:1.0];
    [_imageDown setAlpha:1.0];
    
}

@end
