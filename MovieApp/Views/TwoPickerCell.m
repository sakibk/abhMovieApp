//
//  TwoPickerCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 01/04/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "TwoPickerCell.h"

NSString *const twoPickerCellIdentifier =@"TwoPickerCellIdentifier";
@implementation TwoPickerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.pickerView1.delegate=self;
    self.pickerView2.delegate=self;
    self.pickerView1.dataSource=self;
    self.pickerView2.dataSource=self;
    [_popPicker1 addTarget:self action:@selector(popOneOfTwoPickers:) forControlEvents:UIControlEventTouchUpInside];
    [_popPicker1 setTag:1];
    [_popPicker2 addTarget:self action:@selector(popOneOfTwoPickers:) forControlEvents:UIControlEventTouchUpInside];
    [_popPicker2 setTag:2];
    [_pickerView1 reloadAllComponents];
    [_pickerView2 reloadAllComponents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)firstPickerButtonTitle{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY"];
    [NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:[[_playingDays objectAtIndex:[[_selectedHours playingDayID] integerValue]] playingDate]],[_selectedHours playingHour]];
}

-(IBAction)popOneOfTwoPickers:(id)sender{
    if([sender tag]==1){
        [_popPicker1 setAlpha:0.0];
        [_dropDownImage1 setAlpha:0.0];
    }else if([sender tag]==2){
        [_popPicker2 setAlpha:0.0];
        [_dropDownImage2 setAlpha:0.0];
    }
    [self.delegate popOneOfTwoPickers:sender];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    if([thePickerView tag]==1){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/YYYY"];
        _stringsToShow = [[NSMutableArray alloc] init];
        _playingHours =[[NSMutableArray alloc]init];
        for(DaysPlaying *pd in _playingDays){
            for(Hours *h in pd.playingHours){
                [_stringsToShow addObject:[NSString stringWithFormat:@"%@ - %@",[dateFormatter stringFromDate:pd.playingDate],h.playingHour]];
                [_playingHours addObject:h];
            }
        }
        return [_stringsToShow count];
    }
    else{
       return 5;
    }
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if([thePickerView tag]==1){
        
        return [NSString stringWithFormat:@"%@",[_stringsToShow objectAtIndex:row]];
    }
    else{
        return [NSString stringWithFormat:@"%ld",row+1];
    }
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([thePickerView tag]==1){

        NSLog(@"Selected Tearm: %d. Index of selected term: %d",1,1);
        [_popPicker1 setTitle:[_stringsToShow objectAtIndex:row] forState:UIControlStateNormal];
        [_popPicker1 setAlpha:1.0];
        [_dropDownImage1 setAlpha:1.0];
        [self.delegate pushSelectedHours:[_playingHours objectAtIndex:row]];
    }
    else{
        NSLog(@"Selected number of persons %ld",row);
        [_popPicker2 setTitle:[NSString stringWithFormat:@"%ld",row+1] forState:UIControlStateNormal];
        [_popPicker2 setAlpha:1.0];
        [_dropDownImage2 setAlpha:1.0];
        [self.delegate pushTicketNo:[NSNumber numberWithInteger:row+1]];
    }
    //Here, like the table view you can get the each section of each row if you've multiple sections
    [self.delegate popOneOfTwoPickers:thePickerView];
}



@end
