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
@synthesize cellSet = _cellSet;
@synthesize height = _height;

-(void)configureForFormItem:(CBFormItem *)formItem {
    
    //Set the titlelabel's text to the formItem's title - This may not do anything if the cell doesn't use a titleLabel.
    [self.titleLabel setText:formItem.title];
    
    [self setClipsToBounds:YES];
    
    //Makes it such that the cell cannot be highlighted by tapping when the form isn't editing, or unless the user has specific that this cell should be able to be interacted with even when the form is not editing
    if (!([formItem.formController editing] || formItem.enabledWhenNotEditing)) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //This function call gives any category on this CBCell an opportunity to customize the cell.
    if ([self respondsToSelector:@selector(configureAddonsForFormItem:)]) {
        [self configureAddonsForFormItem:formItem];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

//If the subclass doesn't implement this function then return the default for the Cell Set
-(CGFloat)height {
    return self.cellSet.defaultHeight;
}

-(CGFloat)twoLineHeight {
    return self.cellSet.defaultTwoLineHeight;
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
