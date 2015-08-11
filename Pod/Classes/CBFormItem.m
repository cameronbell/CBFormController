//
//  CBFormItem.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBFormItem.h"
#import "CBFormController.h"
#import "NSObject+Equals.h"
#import "NSString+Equals.h"
#import "NSNumber+Equals.h"

@implementation CBFormItem
@synthesize height,hidden,numberOfTitleLines;
@synthesize cell = _cell;
@synthesize name = _name;
@synthesize engaged = _engaged;
@synthesize type = _type;
@synthesize title = _title;
@synthesize initialValue = _initialValue;
@synthesize enabledWhenNotEditing = _enabledWhenNotEditing;
@synthesize change;
@dynamic save;
@dynamic validate;


-(id)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        _engaged = NO;
    }
    return self;
}

-(CBCell *)cell {
    
    if (_cell) {
        return _cell;
    }
    
    //TODO:Check whether [self class] returns the current class or the bottom subclass
    NSString *cellClass = [self.formController.cellSet cellClassStringForFormItemClass:[self class]];
 
    NSAssert(cellClass, @"cellClass must exist");
    
    //All of the resources from the cocoapod are loaded into the same bundle (which is not the main bundle). So loading the bundle that contains this class will be the same one that contains the nib we want.
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSArray *topLevelObjects = [bundle loadNibNamed:cellClass owner:self options:nil];
    

    
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:NSClassFromString(cellClass)]) {
            _cell = (CBCell *)currentObject;
            break;
        }
    }
    
    [self configureCell:_cell];
    
    return _cell;
}

-(NSObject *)value {
    NSAssert(NO, @"This is an abstract method.");
    return nil;
}

//Returns the appropriate height for the formitem based on the number of lines in the title (default = 1).
-(CGFloat)height {
    switch (self.numberOfTitleLines) {
        case 1: {
            
            return self.formController.cellSet.defaultHeight;
            
            break;
        }
        case 2: {
            
            return self.formController.cellSet.defaultTwoLineHeight;
            
            break;
        }

        default:
            NSAssert(NO, @"Self.numberOfTitleLines should always be either 1 or 2 at present.");
            break;
    }
    
    NSAssert(NO, @"This function should have already returned a value.");
    return 0;
}

//Controls the number of lines that the title can occupy. At present CBFormController only supports values of 1 or 2. Looking to improve upon this in the future.
-(int)numberOfTitleLines {
    return 1;
}

-(void)engage {
    [self setEngaged:YES];
    
    
    /*switch (self.type) {
        case DDVCText: {
            DDVCTextCell *textCell = (DDVCTextCell *)self.cell;
            [textCell.textField setUserInteractionEnabled:YES];
            [textCell.textField becomeFirstResponder];
            break;
        }
        case DDVCDate: {
            
            if (IOS7) {
                [self.delegate updates];
            }else{
                [self.delegate showDatePicker:YES];
            }
            break;
        }
        case DDVCPicker: {
            DDVCPickerCell *pickerCell = (DDVCPickerCell *)self.cell;
            
            int selectedIndex = -1;
            
            //If the formitem already has a selectedIndex then show that
            if ([self.data objectForKey:@"selectedIndex"]) {
                selectedIndex = [[self.data objectForKey:@"selectedIndex"]intValue];
            }else{
                
                //If the formitem does not already have a selectedIndex then get the selectionItems for the picker and make the first one of the selectedIndex/String
                selectedIndex = 0;
                
                NSMutableArray *selectionItems = [self.delegate selectionItemsForPicker:self];
                NSString *selectedString;
                if ([selectionItems count] > 0) {
                    selectedString = [selectionItems objectAtIndex:selectedIndex];
                }
                if (selectedString) {
                    [pickerCell.pickerField setText:selectedString];
                    [self.data setObject:selectedString forKey:@"selectedString"];
                }
                
            }
            
            
            if (IOS7) {
                [self.delegate updates];
                [pickerCell.picker selectRow:selectedIndex inComponent:0 animated:NO];
                [pickerCell.picker setHidden:NO];
            }else{
                [self.delegate showPicker:YES];
                [[self.delegate iOS6Picker] selectRow:selectedIndex inComponent:0 animated:NO];
                
            }
            
            break;
        }
        case DDVCFAQ: {
            [self.delegate updates];
            
            [self.delegate scrollFormTableForHiddenFAQItem:self];
            
            break;
        }
        case DDVCComment: {
            [self.delegate updates];
            DDVCCommentCell *commentCell = (DDVCCommentCell *)self.cell;
            [commentCell.textView setUserInteractionEnabled:YES];
            [commentCell.textView becomeFirstResponder];
            [commentCell.pencilIcon setHidden:YES];
            [commentCell.donelabel setHidden:NO];
            break;
        }
        case DDVCAutoComplete: {
            DDVCAutoCompleteCell *autoComplete = (DDVCAutoCompleteCell *)self.cell;
            
            [autoComplete.autoCompleteTextField setUserInteractionEnabled:YES];
            [autoComplete.autoCompleteTextField becomeFirstResponder];
            break;
        }
        case DDVCPopupPicker: {
            break;
        }
            
            
        default:
            break;
    }
     */
}

-(void)dismiss {
    [self setEngaged:NO];
   
    /*switch (self.type) {
        case DDVCText: {
            DDVCTextCell *textCell = (DDVCTextCell *)self.cell;
            [textCell.textField resignFirstResponder];
            [textCell.textField setUserInteractionEnabled:NO];
            break;
        }
        case DDVCDate: {
            if (IOS7) {
                [self.delegate updates];
            }else{
                [self.delegate showDatePicker:NO];
            }
            break;
        }
        case DDVCPicker: {
            DDVCPickerCell *pickerCell = (DDVCPickerCell *)self.cell;
            //[pickerCell.dropDown hideDropDown:pickerCell.pickerButton];
            
            
            if (IOS7) {
                [self.delegate updates];
                [pickerCell.picker setHidden:YES];
            }else{
                if ([[self.delegate engagedItem] type] != DDVCPicker || [[[self.delegate engagedItem]name] isEqualToString:self.name]) {
                    [self.delegate showPicker:NO];
                }
                
            }
            break;
        }
        case DDVCFAQ:{
            [self.delegate updates];
            break;
        }
        case DDVCComment: {
            DDVCCommentCell *commentCell = (DDVCCommentCell *)self.cell;
            [commentCell.textView setUserInteractionEnabled:NO];
            [commentCell.textView resignFirstResponder];
            [commentCell.pencilIcon setHidden:NO];
            [commentCell.donelabel setHidden:YES];
            [self.delegate updates];
            break;
        }
        case DDVCAutoComplete: {
            DDVCAutoCompleteCell *autoComplete = (DDVCAutoCompleteCell *)self.cell;
            [autoComplete.autoCompleteTextField resignFirstResponder];
            [autoComplete.autoCompleteTextField setUserInteractionEnabled:NO];
            break;
        }
        case DDVCPopupPicker: {
            //TODO: Dismiss the popup
        }
            
        default:
            break;
    }*/
}


//Returns a test for equality based on the formItem's name.
-(BOOL)equals:(CBFormItem *)formItem {
    if ([formItem.name isEqualToString:self.name]) {
        return YES;
    }else{
        return NO;
    }
}

//Most classes will not need to override this function because equals will likely work as the comparator.
//Using a category on NSObject to provide the equals method on NSObject as an abstract method.
-(BOOL)isEdited {
    return ![self.initialValue equals:self.value];
}

-(void)valueChanged {
    
    if (self.change) {
        self.change(self.initialValue,self.value);
    }
    
    
    [self.formController formWasEdited];
    
}

-(BOOL)attemptSave {
    BOOL validationSuccess = YES;
    if (self.validate) {
        validationSuccess = self.validate(self.value);
    }
    
    if (validationSuccess) {
        if (self.save) {
            self.save(self.value);
        }
        
        return YES;
    }else{
        return NO;
    }
}


@end
