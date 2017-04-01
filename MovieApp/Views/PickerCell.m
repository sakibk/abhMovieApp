//
//  PickerCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 30/03/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "PickerCell.h"
#import "Hours.h"

NSString *const pickerCellIdentifier=@"PickerCellIdentifier";

@implementation PickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    [_pickerView setShowsSelectionIndicator:YES];
    _pickerButton.layer.borderWidth =1;
    _pickerButton.layer.cornerRadius=3;
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
}

-(void)setupWithHours:(NSMutableArray<Hours*>*) playingHours{
    _hoursPlaying =[[NSMutableArray alloc]initWithArray:playingHours];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_hoursPlaying count];
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@",[[_hoursPlaying objectAtIndex:row] playingHour]];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    NSLog(@"Selected Tearm: %@. Index of selected term: %ld", [[_hoursPlaying objectAtIndex:row] playingHour], (long)row);
    [self.delegate pushHoursTroughDelegate:[_hoursPlaying objectAtIndex:row]];
    [_pickerButton setAlpha:1.0];
    [_imageDown setAlpha:1.0];
    [self.delegate popPicker:_pickerButton];
    
}

@end
