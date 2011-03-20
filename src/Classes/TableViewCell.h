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
    IBOutlet UILabel *_authorLabel;
    IBOutlet UILabel *_dateLabel;
}

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UIImageView *postImageView;
@property (retain, nonatomic) UILabel *authorLabel;
@property (retain, nonatomic) UILabel *dateLabel;

@end
