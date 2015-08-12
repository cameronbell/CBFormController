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

@synthesize placeholder = _placeholder;
@synthesize save;
@synthesize validate;
@synthesize allowsCustomItems = _allowsCustomItems;
@synthesize items = _items;


-(CBFormItemType)type {
    return PopupPicker;
}

-(void)configureCell:(CBCell *)cell {
    [cell configureForFormItem:self];
}

//Ensures that this FormItem's initialValue can only be set to a string
-(void)setInitialValue:(NSObject *)initialValue {
    if ([initialValue isKindOfClass:[NSString class]]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue of a CBPopupPicker must be a NSString.");
    }
}

//Ensures that this FormItem's value can only be set to a string
-(void)setValue:(NSObject *)value {
    if ([value isKindOfClass:[NSString class]]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value of a CBPopupPicker must be a NSString.");
    }
}

-(NSObject *)value {
    return [(CBPopupPickerCell *)self.cell textField].text;
}

-(BOOL)isEdited {
    return [(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

-(void)selected {
    
    CBPopupPickerView *pickerPopupView = [[CBPopupPickerView alloc]initForFormItem:self withDelegate:self];
    
    MZFormSheetController *pickerPopup = [[MZFormSheetController alloc]initWithViewController:pickerPopupView];
    pickerPopup.shouldDismissOnBackgroundViewTap = YES;
    pickerPopup.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    pickerPopup.cornerRadius = 8.0;
    pickerPopup.portraitTopInset = 6.0;
    pickerPopup.landscapeTopInset = 6.0;
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    pickerPopup.presentedFormSheetSize = CGSizeMake(screenSize.size.width - 40, 350);
    
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
}



@end
