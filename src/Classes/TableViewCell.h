//
//  IOTDTableViewCell.h
//  GDNet_ImageOfTheDay
//
//  Created by Zbigniew Kominek on 3/4/11.
//  Copyright 2011 zbyhoo. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableViewCell : UITableViewCell {
    IBOutlet UILabel *_titleText;
    IBOutlet UIImageView *_postImageView;
@private
    //UIActivityIndicator *_indicator;
}

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *postImageView;

@end
