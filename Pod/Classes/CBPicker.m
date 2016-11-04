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
    
    if (!initialValue || [initialValue isKindOfClass:[NSString class]] || [initialValue respondsToSelector:NSSelectorFromString(self.pickerSelectorString)]) {
        _initialValue = initialValue;
        _value = [initialValue copy];
    }else{
        NSAssert(NO, @"The initialValue is not a string, or does not the selector with name stored in pickerSelectorString");
    }
}

//Ensures that this FormItem's value can only be set to a string or to an object that implements -(NSString *)pickerString
-(void)setValue:(NSObject *)value {
    
    if ([value isKindOfClass:[NSString class]] || [value respondsToSelector:NSSelectorFromString(self.pickerSelectorString)]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value is not a string, or does not the selector with name stored in pickerSelectorString");
    }
}

-(NSObject *)value {
    return _value;
    //return [(CBPickerCell *)self.cell pickerField].text;
}

//Ensuring that this never returns nil so that isEdited works properly.
-(NSObject *)initialValue {
    return [(NSString *)_initialValue length] ? _initialValue : @"";
}

-(BOOL)isEdited {
    return ![self.initialValue isEqual:self.value];
}

-(void)engage {
    
    [super engage];
    
    CBPickerCell *pickerCell = (CBPickerCell *)self.cell;
    
    //Default to the first value in the items array if no value already selected
    int selectedIndex = self.value ? [self.items indexOfObject:self.value] : 0;
    
    //If the formitem does not already have a value then set it to the value of the first one in the array
    if ([self.items count]) {
        
        NSObject *pickerItem = [self.items objectAtIndex:selectedIndex];
        [pickerCell.pickerField setText:[self getPickerStringForItem:pickerItem]];
    }

    //Update the height of the cell
    [self.formController updates];
    
    //Sets the picker to the selectedIndex
    [pickerCell.picker selectRow:selectedIndex inComponent:0 animated:NO];
    
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
        
        if ([self isEdited]) {
            [self valueChanged];
        }
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
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString *)obj;
    }else if([obj respondsToSelector:NSSelectorFromString(self.pickerSelectorString)]) {
        return [obj performSelector:NSSelectorFromString(self.pickerSelectorString) withObject:nil];
    }
}

// Default pickerSelectorString to pickerString
- (NSString *)pickerSelectorString {
    return  _pickerSelectorString ? _pickerSelectorString : @"pickerString";
}

@end
