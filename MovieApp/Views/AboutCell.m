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
    if(![singleActor.biography isEqualToString:@""]){
        _fullBiography.text=singleActor.biography;
    }
    if(singleActor.birthDate!=nil || ![singleActor.birthPlace isEqualToString:@""] ){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd LLLL yyyy"];
        
        _aboutBirth.text = [NSString stringWithFormat:@"%@, %@",[dateFormatter stringFromDate:singleActor.birthDate],singleActor.birthPlace];
    }
}

-(IBAction)openWebsite:(id)sender{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_link]];
}

@end
