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

@synthesize save;
@synthesize validation;
@synthesize allowsCustomItems = _allowsCustomItems;
@synthesize items = _items;
@synthesize didSelectItem;

-(CBFormItemType)type {
    return CBFormItemTypePopupPicker;
}

-(void)configureCell:(CBCell *)cell {
    
    [super configureCell:cell];
    
    [cell configureForFormItem:self];
}

//Ensures that this FormItem's initialValue can only be set to a string
-(void)setInitialValue:(NSObject *)initialValue {
    if (!initialValue || [initialValue isKindOfClass:[NSString class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBPopupPicker must be a NSString.");
    }
}

//Ensures that this FormItem's value can only be set to a string
-(void)setValue:(NSObject *)value {
    
    //If the value is nil or not of type NSString then fail, otherwise set the text of the cell's textField to the value
    if (!value || [value isKindOfClass:[NSString class]]) {
        [[(CBPopupPickerCell *)self.cell textField] setText:(NSString *)value];
    }else{
        NSAssert(NO, @"The value of a CBPopupPicker must be a NSString.");
    }
}

-(NSObject *)value {
    return [(CBPopupPickerCell *)self.cell textField].text;
}

//Ensuring that this never returns nil so that isEdited works properly.
-(NSObject *)initialValue {
    return [(NSString *)_initialValue length] ? _initialValue : @"";
}

-(BOOL)isEdited {
    //No need to worry about value being nil because the default Value of the UITextField is @"".
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

-(void)selected {
    
    CBPopupPickerView *pickerPopupView = [[CBPopupPickerView alloc]initForFormItem:self withDelegate:self];
    
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


-(void)popupPickerForFormItem:(CBFormItem*)formItem didSelectItem:(NSString *)item {
    CBPopupPickerCell *cell =  (CBPopupPickerCell *)self.cell;
    [cell.textField setText:item];
    
    [self.formController mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    
    if ([self isEdited]) {
        [self valueChanged];
    }
    
    if (self.didSelectItem) {
        self.didSelectItem(item);
    }
    
    
    
}



@end
