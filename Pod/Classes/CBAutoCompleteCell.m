//
//  CBAutoCompleteCell.m
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import "CBAutoCompleteCell.h"
#import "CBAutoCompleteOptionCell.h";

@implementation CBAutoCompleteCell


-(void)configureForFormItem:(CBFormItem *)formItem {
    [super configureForFormItem:formItem];
    
    [self.textField setUserInteractionEnabled:NO];
    [self.textField setDelegate:formItem];
    [self.textField setText:(NSString *)formItem.initialValue];
    [self.textField setTag:[formItem.formController rowIndexForFormItem:formItem]];
    [self.textField addTarget:formItem action:@selector(textFieldEditingChange) forControlEvents:UIControlEventEditingChanged];
    [self.textField setKeyboardType:formItem.keyboardType];
    [self.textField setAutoCompleteDelegate:formItem];
    [self.textField setAutoCompleteDataSource:formItem];

    [self.textField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
    [self.textField registerAutoCompleteCellClass:[CBAutoCompleteOptionCell class] forCellReuseIdentifier:@"CBAutoCompleteOptionCell"];
    [self.textField setUserInteractionEnabled:NO];
    [self.textField setReverseAutoCompleteSuggestionsBoldEffect:YES];
    [self.textField setBackgroundColor:[UIColor whiteColor]];

}
@end
