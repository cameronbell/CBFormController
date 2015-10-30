//  @author Cameron Bell
//  @author Julien Guerinet

#import "CBFormItem.h"
#import "CBFormController.h"
#import "NSObject+Equals.h"
#import "NSString+Equals.h"
#import "NSNumber+Equals.h"

@implementation CBFormItem

@dynamic save;
@dynamic validation;

-(id)initWithName:(NSString *)name {
    if (self = [super init]) {
        self.name = name;
        
        _engaged = NO;
        _userInteractionEnabled = YES;
        
        //Sets default keyboard type
        _keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

-(CBCell *)cell {
    
    if (_cell) {
        return _cell;
    }
    
    //Get the class for the cell for this form item from the cellSet
    NSString *cellClass = [self.formController.cellSet cellClassStringForFormItemClass:[self class]];
 
    NSAssert(cellClass, @"cellClass must exist");
    
    //All of the resources from the cocoapod are loaded into the same bundle (which is not the main bundle). So loading the bundle that contains this class will be the same one that contains the nib we want.
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    
    NSArray *topLevelObjects = [bundle loadNibNamed:cellClass owner:self options:nil];
    
    //Gets the cell out of the nib array
    for (id currentObject in topLevelObjects) {
        if ([currentObject isKindOfClass:NSClassFromString(cellClass)]) {
            _cell = (CBCell *)currentObject;
            break;
        }
    }
    
    //Tells the cell what cellSet it belongs to.
    [_cell setCellSet:self.formController.cellSet];
    
    [self configureCell:_cell];
    
    return _cell;
}

-(void)configureCell:(CBCell *)cell {
    [cell setSelectionStyle:[self userInteractionEnabled] ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone];
}

//Returns the appropriate height for the formitem based on the number of lines in the title (default = 1).
-(CGFloat)height {
    switch (self.numberOfTitleLines) {
        case 1: {
            
            return self.cell.height;
            
            break;
        }
        case 2: {
            
            return self.cell.twoLineHeight;
            
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
}

-(void)dismiss {
    [self setEngaged:NO];
}

//Overriding this function to warn users who don't implement this function in a CBFormItem subclass
-(void)setInitialValue:(NSObject *)initialValue {
    NSLog(@"WARNING: This CBFormItem does not implement the initialValue property.");
}

//Overriding this function to warn users who don't implement this function in a CBFormItem subclass
-(void)setValue:(NSObject *)value {
    NSLog(@"WARNING: This CBFormItem does not implement the value property.");
}

//Overriding this function to warn users who don't implement this function in a CBFormItem subclass
-(NSObject *)value {
    NSLog(@"WARNING: This CBFormItem does not implement the value property.");
    return nil; //Figure out how to avoid this warning for formitems that don't implement this
}


//Returns a test for equality based on the formItem's name.
-(BOOL)equals:(CBFormItem *)formItem {
    if ([formItem.name isEqualToString:self.name]) {
        return YES;
    }else{
        return NO;
    }
}


//Implemented by subclasses that can be edited, and tells us whether the formitem has been edited
-(BOOL)isEdited {
    return NO;
}

-(void)valueChanged {
    
    //Calls the change block on the formItem if it exists
    if (self.change) {
        self.change(self.initialValue,self.value);
    }
    
    //Tells the form controller that a formItem's value changed and that it should update things like the navbar
    [self.formController formWasEdited];
    
}

-(BOOL)validate {
    if (self.validation) {
        return self.validation(self.value);
    }
    return YES;
}

-(void)saveValue {
    if (self.save) {
        self.save(self.value);
    }
}

-(void)selected {
    if (self.select) {
        self.select();
    }
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    
    _userInteractionEnabled = userInteractionEnabled;
    
    if(_cell) {
        if (_userInteractionEnabled) {
            [self.cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }else{
            [self.cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }
}

- (void)setIcon:(FAIcon)icon withColor:(UIColor *)color {
    [self setIcon:icon];
    [self setIconColor:color];
}

@end
