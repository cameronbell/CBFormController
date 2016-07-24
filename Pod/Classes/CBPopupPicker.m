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

//Ensures that this FormItem's initialValue can only be set to a string
-(void)setInitialValue:(NSObject *)initialValue {
    if (!initialValue || [initialValue isKindOfClass:[NSArray class]]) {
        _initialValue = initialValue;
        _value = [initialValue copy];
    }else{
        NSAssert(NO, @"The initialValue of a CBPopupPicker must be a NSArray.");
    }
}

//Ensures that this FormItem's value can only be set to a array
-(void)setValue:(NSObject *)value {
    
    //If the value is nil or not of type NSString then fail, otherwise set the text of the cell's textField to the value
    if (!value || [value isKindOfClass:[NSArray class]]) {
        //[[(CBPopupPickerCell *)self.cell textField] setText:(NSString *)value];
        _value = value;
        [[(CBPopupPickerCell *)self.cell textField] setText:[(NSArray *)value componentsJoinedByString:@", "]];
    }else{
        NSAssert(NO, @"The value of a CBPopupPicker must be a NSString.");
    }
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
