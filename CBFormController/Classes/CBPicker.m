//
//  CBPicker.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBPicker.h"
#import "CBPickerCell.h"

@implementation CBPicker
@synthesize save;
@synthesize validation;
@synthesize items = _items;


-(CBFormItemType)type {
    return CBFormItemTypePicker;
}

-(void)configureCell:(CBCell *)cell {
    [super configureCell:cell];
    [cell configureForFormItem:self];
}

-(void)setInitialValue:(NSObject *)initialValue {
    
    if (!initialValue || [initialValue isKindOfClass:[NSString class]] ||
        [initialValue respondsToSelector:NSSelectorFromString(self.pickerSelectorString)] ||
        [self getPickerStringForItem]) {
        _initialValue = initialValue;
        //_value = [initialValue copy];
    }else{
        NSAssert(NO, @"The initialValue is not a string, or does not the selector with name stored in pickerSelectorString");
    }
}

//Ensures that this FormItem's value can only be set to a string or to an object that implements -(NSString *)pickerString
-(void)setValue:(NSObject *)value {
    
    if (!value || [value isKindOfClass:[NSString class]] ||
        [value respondsToSelector:NSSelectorFromString(self.pickerSelectorString)] ||
        [self getPickerStringForItem]) {
        _value = value;
        
        [self configurePicker];
        
    }else{
        NSAssert(NO, @"The value is not a string, or does not the selector with name stored in pickerSelectorString");
    }
}

// Sets the picker to the right position and sets the value of the picker's textfield
-(void)configurePicker {
    
    // Set the picker to the value
    int indexOfValue = [self.items indexOfObject:self.value];
    CBPickerCell *cell = (CBPickerCell *)self.cell;
    [cell.picker selectRow:indexOfValue inComponent:0 animated:YES];
    
    // Set the value's string in the picker field
    [cell.pickerField setText:[self getPickerStringForItem:self.value]];
}

-(NSObject *)value {
    return _value ? _value : _initialValue;
    //return [(CBPickerCell *)self.cell pickerField].text;
}

//Ensuring that this never returns nil so that isEdited works properly.
-(NSObject *)initialValue {
    return _initialValue;
}

-(BOOL)isEdited {
    return ![self.initialValue isEqual:self.value];
}

-(void)engage {
    
    [super engage];
    
    CBPickerCell *pickerCell = (CBPickerCell *)self.cell;
    
    //If the formitem does not already have a value then set it to the value of the first one in the array
    if (self.value) {
        [self configurePicker];
    }else if([self.items count]) {
        [self setValue:[self.items objectAtIndex:0]];
        
        if ([self isEdited]) {
            [self valueChanged];
        }
    }

    //Update the height of the cell
    [self.formController updates];
    
    //Make the picker visible
    [pickerCell.picker setHidden:NO];
}

-(void)dismiss {
    
    [super dismiss];
    
    CBPickerCell *pickerCell = (CBPickerCell *)self.cell;
    
    //Adjusts the height of the cell appropriately
    [self.formController updates];
    
    //Hidse the picker
    [pickerCell.picker setHidden:YES];
    
}

- (void)setItems:(NSArray *)items {
    _items = items;
    
    CBPickerCell *pickerCell = (CBPickerCell *)self.cell;
    
    // If this is called before the form has a cellSet then pickerCell will be nil
    if (pickerCell) {
        [pickerCell.picker reloadAllComponents];
        
        // Check for equality with the isEqual method
        if(![_items containsObject:self.value]) {
            [self clear];
        }
    }
}

//If the cell is engaged return it's engaged height, otherwise load the default
-(CGFloat)height {
    if (self.engaged) {
        return [(CBPickerCell *)[self cell] engagedHeight];
    }else {
        return [super height];
    }
}

#pragma mark - Picker View Delegate/DataSource Methods

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.items count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.items objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    CBPickerCell *cell = (CBPickerCell *)self.cell;
    
    //Verify that there is at least one item to pick from before setting it
    if (self.items.count > 0) {

        NSObject *selectedObj = [self.items objectAtIndex:row];
        
        [self setValue:selectedObj];
        
        [cell.pickerField setText:[self getPickerStringForItem:selectedObj]];
        [self valueChanged];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
        [tView setFont:[UIFont fontWithName:@"Helvetica-Neue" size:18]];
        [tView setAdjustsFontSizeToFitWidth:YES];
        [tView setTextAlignment:NSTextAlignmentCenter];
        [tView setBackgroundColor:[UIColor clearColor]];
        
    }
    // Fill the label text here
    NSObject *pickerItem = [self pickerView:pickerView titleForRow:row forComponent:component];
    [tView setText:[self getPickerStringForItem:pickerItem]];
    return tView;
}

- (NSString *)getPickerStringForItem:(NSObject *)obj {
    
    // Get string from the formController instead of off the objects
    if (self.getPickerStringForItem) {
        
        // Ensure result is a string if obj doesn't exist
        NSString *pickerString = obj ? self.getPickerStringForItem(obj) : @"";
        
        NSAssert(pickerString, @"getPickerStringForItem block must return string for item");
        
        return pickerString;
    }
    
    // Get the string off the object
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }else if([obj respondsToSelector:NSSelectorFromString(self.pickerSelectorString)]) {
        return [obj performSelector:NSSelectorFromString(self.pickerSelectorString) withObject:nil];
    }
    return @"";
}

// Default pickerSelectorString to pickerString
- (NSString *)pickerSelectorString {
    return  _pickerSelectorString ? _pickerSelectorString : @"pickerString";
}

- (void)clear {
    _value = nil;
    CBPickerCell *pickerCell = (CBPickerCell *)self.cell;
    [pickerCell.pickerField setText:@""];
}

@end
