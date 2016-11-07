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
    
    //Cast the initialValue to an MLPAutoCompletionObject conforming NSObject and set the
    // textfield to the value of its autocompleteString
    NSObject<MLPAutoCompletionObject> *obj = formItem.initialValue;
    [self.textField setText:obj.autocompleteString];
    
    //User interaction should start disabled
    [self.textField setUserInteractionEnabled:NO];
    
    //Set the textfields delegates
    [self.textField setDelegate:formItem];
    [self.textField setAutoCompleteDelegate:formItem];
    [self.textField setAutoCompleteDataSource:formItem];
    
    //[self.textField setTag:[formItem.formController rowIndexForFormItem:formItem]];
    //Add an observer when the textField editing status changes
    [self.textField addTarget:formItem action:@selector(textFieldEditingChange)
             forControlEvents:UIControlEventEditingChanged];
    
    //Set the keyboard type for the textfield to that of the formitem
    [self.textField setKeyboardType:formItem.keyboardType];
    
    //Make the autocomplete table load on top of the keyboard
    [self.textField setAutoCompleteTableAppearsAsKeyboardAccessory:YES];
    
    //Register the cell that should be used in the autocomplete table
    [self.textField registerAutoCompleteCellClass:[CBAutoCompleteOptionCell class]
                           forCellReuseIdentifier:@"CBAutoCompleteOptionCell"];
    
    //Turn on the Bold effect
    [self.textField setReverseAutoCompleteSuggestionsBoldEffect:YES];
    
    //Set the background colour of the text field to white
    [self.textField setBackgroundColor:[UIColor whiteColor]];

}
@end
