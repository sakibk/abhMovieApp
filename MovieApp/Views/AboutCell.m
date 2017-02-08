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
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupWithActor:(Actor *)singleActor{
    if (singleActor.homePage!=nil) {
        NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
        _websiteLink.attributedText = [[NSAttributedString alloc] initWithString:singleActor.homePage
                                                                      attributes:underlineAttribute];
    }
    if(singleActor.biography!=nil){
        _fullBiography.text=singleActor.biography;
    }
    if(singleActor.birthDate!=nil || singleActor.birthPlace!=nil ){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd LLLL yyyy"];
        
        _aboutBirth.text = [NSString stringWithFormat:@"%@, %@",[dateFormatter stringFromDate:singleActor.birthDate],singleActor.birthPlace];
    }
}

@end
