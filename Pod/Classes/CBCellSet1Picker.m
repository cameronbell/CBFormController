//
//  CBCellSet1Picker.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBCellSet1Picker.h"

@implementation CBCellSet1Picker

-(void)configureForFormItem:(CBFormItem *)formItem {

    [super configureForFormItem:formItem];
    
    //Sets the title of the cell to the placeholder
    [self.pickerField setPlaceholder:formItem.title];
}

//Returns the height of the cell when the formitem is engaged and the picker is shown
-(CGFloat)engagedHeight {
    return 180.0f;
}

@end
