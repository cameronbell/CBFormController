//
//  CBCellSet1PopupPicker.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCellSet2PopupPicker.h"

@implementation CBCellSet2PopupPicker

-(void)configureForFormItem:(CBPopupPicker *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textField setPlaceholder:formItem.title];
    
}

@end
