//
//  AboutCell.m
//  MovieApp
//
//  Created by Sakib Kurtic on 08/02/2017.
//  Copyright © 2017 Sakib Kurtic. All rights reserved.
//

#import "AboutCell.h"

NSString *const aboutCellIdentifier=@"AboutCellIdentifier";

@implementation AboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupLabels];
}

-(void)setupLabels{
    [_fullBioButton setTitle:@"See full bio" forState:UIControlStateNormal];
    [_fullBioButton addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupWithActor:(Actor *)singleActor{
    if(![singleActor.biography isEqualToString:@""]){
        _fullBiography.text=singleActor.biography;
    }
}

-(IBAction)changeButton:(id)sender{
    if([_fullBioButton.currentTitle isEqualToString:@"See full bio"]){
        [_fullBioButton setTitle:@"Hide" forState:UIControlStateNormal];
    }
    else{
        [_fullBioButton setTitle:@"See full bio" forState:UIControlStateNormal];
    }
    [self.delegate colideColapse];
}


-(void)colideColapse{
    
}

@end
