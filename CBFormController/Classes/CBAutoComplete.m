//
//  CBAutoComplete.m
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import "CBAutoComplete.h"
#import "CBAutoCompleteCell.h"



@interface CBAutoCompleteItemWrapper : NSObject <MLPAutoCompletionObject>

@property (nonatomic,retain) NSObject *object;
@property (nonatomic,retain) NSString *selectorString;

- (NSString *)autocompleteString;

@end

@implementation CBAutoCompleteItemWrapper

- (id)initWithObject:(NSObject<MLPAutoCompletionObject> *)obj usingString:(NSString *)selector {
    if (self = [super init]) {
        _object = obj;
        _selectorString = selector;
    }
    return self;
}
- (NSString *)autocompleteString {
    return [self.object performSelector:NSSelectorFromString(_selectorString)];
}

@end






@interface CBAutoComplete () {
}

@end

@implementation CBAutoComplete
@synthesize save,validation;

- (id)initWithName:(NSString *)name withSelectorString:(NSString *)selectorString {
    if (self = [super initWithName:name]) {
        _selectorString = selectorString;
    }
    return self;
}

-(CBFormItemType)type {
    return CBFormItemTypeAutoComplete;
}

-(void)configureCell:(CBCell *)cell {
    [super configureCell:cell];
    [cell configureForFormItem:self];
}


-(void)setInitialValue:(NSObject *)initialValue {
    
    if (!initialValue || [initialValue respondsToSelector:NSSelectorFromString(self.selectorString)]) {
        _initialValue = initialValue;
        _value = initialValue;
    }else{
        NSAssert(NO, @"The initialValue does not implement the chosen selectorString.");
    }
}

//Ensures that this FormItem's value can only be set to a string
-(void)setValue:(NSObject *)value {
    
    if (!value || [value respondsToSelector:NSSelectorFromString(self.selectorString)]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value does not implement the chosen selectorString.");
    }
}


-(NSObject *)value {
    //If no object has been selected return the initialValue
    return _value; // ? _value : ([self initialValue];
}

-(BOOL)isEdited {
    // If they are both nil, return no
    if (!self.initialValue && !self.value) {
        return false;
    }
    
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
        
        NSArray *suggestions = self.getAutoCompletions(string);
        
        // Wrap suggestion objects in wrapper to give them the <MLPAutoCompleteObject> conformance
        NSMutableArray *wrappedSuggestions = [NSMutableArray array];
        for (NSObject *obj in suggestions) {
            [wrappedSuggestions addObject:[[CBAutoCompleteItemWrapper alloc]initWithObject:obj usingString:self.selectorString]];
        }

        //Call getAutoCompletions with the queryString and pass the result back into the handler
        handler(wrappedSuggestions);
        
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
    
    // Extract object from wrapper
    NSObject *obj = [(CBAutoCompleteItemWrapper *)selectedObject object];
    
    // Save the selected value
    [self setValue:obj];
    
    //Dismiss this formItem
    [self dismiss];
}

- (void)autoCompleteTextFieldCleared:(MLPAutoCompleteTextField *)textField {
    //Do nothing
}

-(void)clear {
   
    CBAutoCompleteCell *cell = (CBAutoCompleteCell *)self.cell;
    [cell.textField setText:@""];
    _value = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //Scroll the table to the top
    MLPAutoCompleteTextField *autoCompleteField = (MLPAutoCompleteTextField *)textField;
    [autoCompleteField.autoCompleteTableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    
    return YES;
}
@end
