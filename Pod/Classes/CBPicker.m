//
//  CBPicker.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-13.
//
//

#import "CBPicker.h"

@implementation CBPicker

- (void)configure {
    [super configure];
    [self.pickerField setPlaceholder:self.placeholder];
    [self.pickerField setUserInteractionEnabled:NO];
    
    //Set delegate to the formitem
    [self.picker setDelegate:self];
    [self.picker setDataSource:self];
    
    //Set initial value
    [self.pickerField setText:(NSString *)self.initialValue];
}

- (NSObject *)value {
    return self.pickerField.text;
}

//Ensuring that this never returns nil so that isEdited works properly.
- (NSObject *)initialValue {
    return [(NSString *)super.initialValue length] ? super.initialValue : @"";
}

- (BOOL)isEdited {
    return ![(NSString *)self.initialValue isEqualToString:(NSString *)self.value];
}

- (void)engage {
    [super engage];
    
    //Default to the first value in the items array
    int selectedIndex = 0;
    
    //If the formitem already has a value then set the picker to that value
    if ([(NSString *)self.value length]) {
        selectedIndex = [self indexOfStringInPicker:(NSString *)self.value];
    } else {
        //If the formitem does not already have a value then set it
        //  to the value of the first one in the array
        if ([self.items count]) {
            [self.pickerField setText:[self.items objectAtIndex:selectedIndex]];
        }
    }

    //Update the height of the cell
    [self.formController updates];
    
    //Sets the picker to the selectedIndex
    [self.picker selectRow:selectedIndex inComponent:0 animated:NO];
    
    //Make the picker visible
    [self.picker setHidden:NO];
}

- (int)indexOfStringInPicker:(NSString *)string {
    for (int i = 0; i < [self.items count]; i ++) {
        if ([[self.items objectAtIndex:i] isEqualToString:string]) {
            return i;
        }
    }
    
    //String not found
    return -1;
}

- (void)dismiss {
    [super dismiss];
    
    //Adjusts the height of the cell appropriately
    [self.formController updates];
    
    //Hidse the picker
    [self.picker setHidden:YES];
    
}

//If the cell is engaged return it's engaged height, otherwise load the default
- (CGFloat)height {
    if (self.engaged) {
        return self.engagedHeight;
    } else {
        return [super height];
    }
}

#pragma mark - Picker View Delegate/DataSource Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.items count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row
           forComponent:(NSInteger)component {
    return [self.items objectAtIndex:row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
    [self.pickerField setText:[self.items objectAtIndex:row]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
          forComponent:(NSInteger)component reusingView:(UIView *)view {
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

//Returns the height of the cell when the formitem is engaged and the picker is shown
- (CGFloat)engagedHeight {
    return 180.0f;
}

//Checks that the given value is a String
- (void) validateValue:(NSObject *)value {
    if (![value isKindOfClass:[NSString class]]) {
        NSAssert(NO, @"The value of a CBPicker must be a NSString.");
    }
}

@end
