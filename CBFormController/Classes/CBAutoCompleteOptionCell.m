//
//  AutoCompleteOptionCell.m
//  ImmunizeON_V106_Update1
//
//  Created by Cameron Bell on 2014-05-08.
//  Copyright (c) 2014 Cameron Bell. All rights reserved.
//

#import "CBAutoCompleteOptionCell.h"

@implementation CBAutoCompleteOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
