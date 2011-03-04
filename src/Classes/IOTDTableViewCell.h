//
//  IOTDTableViewCell.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/4/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface IOTDTableViewCell : UITableViewCell {
    IBOutlet UILabel *_titleText;
    
@private
    //UIActivityIndicator *_indicator;
}

@property (retain) UILabel* titleLabel;

//- (void)setLabelText:(NSString*)text;

@end
