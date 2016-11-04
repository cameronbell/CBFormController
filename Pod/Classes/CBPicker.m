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
    
    if (!initialValue || [initialValue isKindOfClass:[NSString class]] || [initialValue respondsToSelector:@selector(pickerString)]) {
        _initialValue = initialValue;
        _value = [initialValue copy];
    }else{
        NSAssert(NO, @"The initialValue is not a string, or does not implement -(NSString *)pickerString");
    }
}

//Ensures that this FormItem's value can only be set to a string or to an object that implements -(NSString *)pickerString
-(void)setValue:(NSObject *)value {
    
    if ([value isKindOfClass:[NSString class]] || [value respondsToSelector:@selector(pickerString)]) {
        _value = value;
    }else{
        NSAssert(NO, @"The value is not a string, or does not implement -(NSString *)pickerString");
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
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

-(void)engage {
    
    [super engage];
    
    CBPickerCell *pickerCell = (CBPickerCell *)self.cell;
    
    //Default to the first value in the items array
    int selectedIndex = 0;
    
    //If the formitem already has a value then set the picker to that value
    if ([(NSString *)self.value length]) {
        
        selectedIndex = [self indexOfStringInPicker:(NSString *)self.value];

    }else{
        //If the formitem does not already have a value then set it to the value of the first one in the array
        if ([self.items count]) {
            [pickerCell.pickerField setText:[self.items objectAtIndex:selectedIndex]];
        }
    }

    //Update the height of the cell
    [self.formController updates];
    
    //Sets the picker to the selectedIndex
    [pickerCell.picker selectRow:selectedIndex inComponent:0 animated:NO];
    
    //Make the picker visible
    [pickerCell.picker setHidden:NO];
    
}

-(int)indexOfStringInPicker:(NSString *)string {
    
    int index = 0;
    for (NSString *item in self.items) {
        if ([item isEqualToString:string]) {
            return index;
        }
        index++;
    }
    
    //String not found
    return -1;
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
        
        if ([selectedObj isKindOfClass:[NSString class]]) {
            [cell.pickerField setText:(NSString *)selectedObj];
        }else if([selectedObj respondsToSelector:@selector(pickerString:)]) {
            [cell.pickerField setText:[selectedObj performSelector:@selector(pickerString) withObject:nil]];
        }
        
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
    [tView setText:[self pickerView:pickerView titleForRow:row forComponent:component]];
    return tView;
}



@end
