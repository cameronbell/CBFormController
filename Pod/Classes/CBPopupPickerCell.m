//
//  CBPopupPickerCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBPopupPickerCell.h"

@implementation CBPopupPickerCell
@synthesize textField = _textField;


-(void)configureForFormItem:(CBPopupPicker *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textField setPlaceholder:formItem.placeholder];
    [self.textField setText:[(NSArray *)formItem.initialValue componentsJoinedByString:@", "]];
    [self.textField setUserInteractionEnabled:NO];

}


@end
