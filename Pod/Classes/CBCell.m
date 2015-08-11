//
//  CBCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBCell.h"
#import "CBFormController.h"
#import <objc/runtime.h>


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

-(void)setCustomPropertyWithObject:(NSObject *)icon forKey:(const void *)key {
    objc_setAssociatedObject(self, key,
                             icon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

-(NSObject *)getCustomPropertyWithKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}


@end
