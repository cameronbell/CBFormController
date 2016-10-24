//
//  CBPopupPicker.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBPopupPicker.h"
#import "CBFormController.h"
#import "CBPopupPickerCell.h"

#import "MZFormSheetController.h"

@implementation CBPopupPicker
@synthesize validation,save,didSelectItems;

-(CBFormItemType)type {
    return CBFormItemTypePopupPicker;
}

-(void)configureCell:(CBCell *)cell {
    
    [super configureCell:cell];
    
    [cell configureForFormItem:self];
}


-(void)setInitialValue:(NSObject *)initialValue {
    
    //If the initialValue passed in is an array then take it as is
    if ([initialValue isKindOfClass:[NSArray class]]) {
        _initialValue = initialValue;
        _value = [initialValue copy];
    }
    //If the initial value passed in is an object, put it in an array
    else if(initialValue) {
        _initialValue = @[initialValue];
        _value = [_initialValue copy];
    }
    //If the initial value is nil, just set the initialValue and the value to arrays
    else {
        _initialValue = @[];
        _value = @[];
    }
}

/** 
 If the _value array has at least one object in it, return it, otherwise return nil
*/
-(NSObject *)singleValue {
    return [(NSArray *)_value count] >= 1 ? [(NSArray *)_value objectAtIndex:0] : nil;
}

//Ensures that this FormItem's value can only be set to a array
-(void)setValue:(NSObject *)value {
    
    //TODO: Making the assumption here that the array objects are strings
    
    //If the value passed in is an array then take it as is
    if ([value isKindOfClass:[NSArray class]]) {
        _value = value;
        
    }
    //If the initial value passed in is an object, put it in an array
    else if(value) {
        _value = @[value];
        
    }
    //If the initial value is nil, just set the initialValue and the value to arrays
    else {
        _value = @[];
    }
    
    [[(CBPopupPickerCell *)self.cell textField] setText:[(NSArray *)_value componentsJoinedByString:@", "]];

//    
//    //If the value is nil or not of type NSString then fail, otherwise set the text of the cell's textField to the value
//    if (!value || [value isKindOfClass:[NSArray class]]) {
//        //[[(CBPopupPickerCell *)self.cell textField] setText:(NSString *)value];
//        _value = value;
//        [[(CBPopupPickerCell *)self.cell textField] setText:[(NSArray *)value componentsJoinedByString:@", "]];
//    }else{
//        NSAssert(NO, @"The value of a CBPopupPicker must be a NSArray.");
//    }
}

-(NSObject *)value {
    return _value;
}

//Ensuring that this never returns nil so that isEdited works properly.
-(NSObject *)initialValue {
    return _initialValue ? _initialValue : @[];
}

-(BOOL)isEdited {
    //No need to worry about value being nil because the default Value of the UITextField is @"".
    return ![[(NSArray *)self.initialValue componentsJoinedByString:@", "] isEqualToString:[(NSArray *)self.value componentsJoinedByString:@", "]];
}

-(void)selected {
    
    CBPopupPickerView *pickerPopupView = [[CBPopupPickerView alloc]initForFormItem:self withDelegate:self allowsMultipleSelection:_allowsMultipleSelection allowsCustomItems:_allowsCustomItems selections:self.value];
    
    MZFormSheetController *pickerPopup = [[MZFormSheetController alloc]initWithViewController:pickerPopupView];
    pickerPopup.shouldDismissOnBackgroundViewTap = YES;
    pickerPopup.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    pickerPopup.cornerRadius = 8.0;
    pickerPopup.landscapeTopInset = 6.0;
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    pickerPopup.presentedFormSheetSize = CGSizeMake(screenSize.size.width - 40, 350);
    pickerPopup.portraitTopInset = (screenSize.size.height-pickerPopup.presentedFormSheetSize.height)/2;
    
    pickerPopup.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [pickerPopup presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
    
    [super selected];
}


-(void)popupPickerForFormItem:(CBFormItem*)formItem didSelectItems:(NSArray *)items {
    CBPopupPickerCell *cell =  (CBPopupPickerCell *)self.cell;
    self.value = items;
    
    //Create comma delimited string of the items
    NSString *itemsString = [items componentsJoinedByString:@", "];
    
    [cell.textField setText:itemsString];
    
    [self.formController mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    
    if ([self isEdited]) {
        [self valueChanged];
    }
    
    if (self.didSelectItems) {
        self.didSelectItems(items);
    }
}

@end
