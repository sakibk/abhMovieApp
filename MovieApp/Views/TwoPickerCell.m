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
    [_popPicker1 addTarget:self action:@selector(popPickerOne:) forControlEvents:UIControlEventTouchUpInside];
    [_popPicker2 addTarget:self action:@selector(popPickerTwo:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)popPickerOne:(id)sender{
    [_popPicker1 setAlpha:0.0];
    [_dropDownImage1 setAlpha:0.0];
}

-(IBAction)popPickerTwo:(id)sender{
    [_popPicker2 setAlpha:0.0];
    [_dropDownImage2 setAlpha:0.0];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 1;
}


- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@",@"AAAA"];
}


- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    //Here, like the table view you can get the each section of each row if you've multiple sections
    NSLog(@"Selected Tearm: %d. Index of selected term: %d",1,1);
    [_popPicker1 setAlpha:1.0];
    [_dropDownImage1 setAlpha:1.0];
    
}



@end
