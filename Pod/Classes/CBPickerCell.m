//
//  CBPickerCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBPickerCell.h"

@implementation CBPickerCell
@synthesize engagedHeight = _engagedHeight;

-(void)configureForFormItem:(CBPicker *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.pickerField setPlaceholder:formItem.placeholder];
    [self.pickerField setUserInteractionEnabled:NO];
    
    //Set delegate to the formitem
    [self.picker setDelegate:formItem];
    [self.picker setDataSource:formItem];
    
    //Set initial value
    [self.pickerField setText:(NSString *)formItem.initialValue];
}

//Returns the height of the cell when the formitem is engaged and the picker is shown
-(CGFloat)engagedHeight {
    return 180.0f;
}

@end
