//
//  CBCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBCell.h"
#import "CBFormController.h"


@implementation CBCell

-(void)configureForFormItem:(CBFormItem *)formItem {
    //Do Nothing
    
    if (!([formItem.formController editing] || formItem.enabledWhenNotEditing)) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
