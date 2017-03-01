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
    _link=[[NSString alloc]init];
    [_fullBioButton addTarget:self action:@selector(changeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithActor:(Actor *)singleActor{
    if (![singleActor.homePage isEqualToString:@""] && singleActor.homePage!=nil) {
        [self.websiteLink setTitle:singleActor.homePage forState:UIControlStateNormal];
        [self.websiteLink addTarget:self action:@selector(openWebsite:) forControlEvents:UIControlEventTouchUpInside];
        _link=singleActor.homePage;
    }
    else{
        [self.websiteLink setTintColor:[UIColor colorWithRed:137 green:136 blue:133 alpha:1.0]];
    }
    if(![singleActor.biography isEqualToString:@""]){
        _fullBiography.text=singleActor.biography;
    }
    if(singleActor.birthDate!=nil || ![singleActor.birthPlace isEqualToString:@""] ){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd LLLL yyyy"];
        
        _aboutBirth.text = [NSString stringWithFormat:@"%@, %@",[dateFormatter stringFromDate:singleActor.birthDate],singleActor.birthPlace];
    }
}

-(IBAction)changeButton:(id)sender{
    [self.delegate colideColapse];
//    [self colideColapse];
}

-(void)colideColapse{
    if([_fullBioButton.currentTitle isEqualToString:@"See full bio"]){
        [_fullBioButton setTitle:@"Hide" forState:UIControlStateNormal];
    }
    else{
        [_fullBioButton setTitle:@"See full bio" forState:UIControlStateNormal];
    }
}

-(IBAction)openWebsite:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_link]];
}

@end
