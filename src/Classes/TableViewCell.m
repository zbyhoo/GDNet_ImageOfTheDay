//
//  IOTDTableViewCell.m
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/4/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell

@synthesize titleLabel=_titleText;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}

- (void)setLabelText:(NSString*)text {
    _titleText.text = text;
}

- (void)dealloc {
    [super dealloc];
}


@end
