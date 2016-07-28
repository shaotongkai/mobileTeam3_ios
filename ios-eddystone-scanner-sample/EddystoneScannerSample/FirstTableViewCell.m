//
//  FirstTableViewCell.m
//  EddystoneScannerSample
//
//  Created by Robert Pattinson on 16/7/28.
//  Copyright © 2016年 Google, Inc. All rights reserved.
//

#import "FirstTableViewCell.h"

@implementation FirstTableViewCell

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
