//
//  CBAutoComplete.m
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import "CBAutoComplete.h"
#import "CBAutoCompleteCell.h"

@interface CBAutoComplete () {
    NSObject *_selectedObject;
}

@end

@implementation CBAutoComplete
@synthesize save,validation;


-(CBFormItemType)type {
    return CBFormItemTypeAutoComplete;
}

-(void)configureCell:(CBCell *)cell {
    [super configureCell:cell];
    [cell configureForFormItem:self];
}

//Ensures that this FormItem's initialValue can only be set to a string
-(void)setInitialValue:(NSObject *)initialValue {
    
    if (!initialValue || [initialValue isKindOfClass:self.objectClass]) {
        _initialValue = initialValue;
    }else{
        NSAssert(NO, @"The initialValue is a member of the wrong class.");
    }
}

//Ensures that this FormItem's value can only be set to a string
-(void)setValue:(NSObject *)value {
    
    //Assert against class being null
    NSAssert(self.class, @"User must set the Class property of this FormItem.");
    
    //Ensure that the value being set is kind of class self.class
    if ([value isKindOfClass:self.class]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value is a member of the wrong class.");
    }
}


-(NSObject *)value {
    //If no object has been selected return the initialValue
    return _selectedObject ? _selectedObject : [self initialValue];
}

//TODO: Is is alright for this to be nil?
//TODO: I probably don't need to override this
-(NSObject *)initialValue {
    return _initialValue;
}

-(BOOL)isEdited {
    //isEqual should be overrided by the objects being passed in so that they are
    //compared by their properties values and not there references
    return ![self.initialValue isEqual:self.value];
}

-(void)engage {
    [super engage];
    
    CBAutoCompleteCell *textCell = (CBAutoCompleteCell *)self.cell;
    
    [textCell.textField setUserInteractionEnabled:YES];
    [textCell.textField becomeFirstResponder];
}

-(void)dismiss {
    [super dismiss];
    
    CBAutoCompleteCell *textCell = (CBAutoCompleteCell *)self.cell;
    [textCell.textField resignFirstResponder];
    [textCell.textField setUserInteractionEnabled:NO];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //Let the formController decide the actual return value of this function as it manages the selection of formitems in response to the return key.
    return [self.formController textFieldShouldReturnForFormItem:self];
    
}

-(void)textFieldEditingChange {
    if ([self isEdited]) {
        [self valueChanged];
    }
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void(^)(NSArray *suggestions))handler {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        
        //Call getAutoCompletions with the queryString and pass the result back into the handler
        handler(self.getAutoCompletions(string));
        
    });
}

- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:cell.frame];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    
    [cell setBackgroundView:backgroundView];
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Store the selected object
    _selectedObject = selectedObject;
    
    //Dismiss this formItem
    [self dismiss];
}

- (void)autoCompleteTextFieldCleared:(MLPAutoCompleteTextField *)textField {
    //Do nothing
}

-(void)clear {
   
    CBAutoCompleteCell *cell = (CBAutoCompleteCell *)self.cell;
    [cell.textField setText:@""];
    _selectedObject = nil;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //Scroll the table to the top
    MLPAutoCompleteTextField *autoCompleteField = (MLPAutoCompleteTextField *)textField;
    [autoCompleteField.autoCompleteTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    return YES;
}
@end
