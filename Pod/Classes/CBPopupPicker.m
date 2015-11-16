//
//  CBPopupPicker.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBPopupPicker.h"
#import "CBFormController.h"
#import "MZFormSheetController.h"

@implementation CBPopupPicker

-(void)configure {
    [super configure];
    
    [self.textField setPlaceholder:self.placeholder];
    [self.textField setText:(NSString *)self.initialValue];
    [self.textField setUserInteractionEnabled:NO];
}

-(NSObject *)value {
    return self.textField.text;
}

//Ensuring that this never returns nil so that isEdited works properly.
-(NSObject *)initialValue {
    return [(NSString *)super.initialValue length] ? super.initialValue : @"";
}

-(BOOL)isEdited {
    //No need to worry about value being nil because the default Value of the UITextField is @"".
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

-(void)selected {
    CBPopupPickerView *pickerPopupView = [[CBPopupPickerView alloc] initForFormItem:self
                                                                      withDelegate:self];
    MZFormSheetController *pickerPopup = [[MZFormSheetController alloc]
                                          initWithViewController:pickerPopupView];
    pickerPopup.shouldDismissOnBackgroundViewTap = YES;
    pickerPopup.transitionStyle = MZFormSheetTransitionStyleSlideFromBottom;
    pickerPopup.cornerRadius = 8.0;
    pickerPopup.portraitTopInset = 6.0;
    pickerPopup.landscapeTopInset = 6.0;
    
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    pickerPopup.presentedFormSheetSize = CGSizeMake(screenSize.size.width - 40, 350);
    
    pickerPopup.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask =
            presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [pickerPopup presentAnimated:YES
               completionHandler:^(UIViewController *presentedFSViewController) {}];
    
    [super selected];
}


-(void)popupPickerForFormItem:(CBFormItem *)formItem didSelectItem:(NSString *)item {
    [self.textField setText:item];
    [self.formController mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    
    if ([self isEdited]) {
        [self valueChanged];
    }
    
    if (self.didSelectItem) {
        self.didSelectItem(item);
    }
}

//Checks that the given value is a String
- (void) validateValue:(NSObject *)value {
    if (![value isKindOfClass:[NSString class]]) {
        NSAssert(NO, @"The value of a CBPopupPicker must be a NSString.");
    }
}

@end
