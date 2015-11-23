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
        
        //Sets the default values
        _keyboardType = UIKeyboardTypeDefault;
        _defaultHeight = 45;
        _defaultTwoLineHeight = 70;
    }
    return self;
}

- (void)configure {
    [self setSelectionStyle:[self userInteractionEnabled] ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone];
    
    [self setClipsToBounds:YES];
    
    //Set the titlelabel's text to the formItem's title
    [self.titleLabel setText:self.title];
    
    //Makes it such that the cell cannot be highlighted by tapping when the form isn't editing, or unless the user has specific that this cell should be able to be interacted with even when the form is not editing
    if (!([self.formController editing])) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}

//Returns the appropriate height for the formitem based on the number of lines in the title (default = 1).
- (CGFloat)height {
    switch (self.numberOfTitleLines) {
        case 1:
            return self.defaultHeight;
        case 2:
            return self.defaultTwoLineHeight;
        default:
            NSAssert(NO, @"Self.numberOfTitleLines should always be either 1 or 2 at present.");
    }
}

//Controls the number of lines that the title can occupy. At present CBFormController only supports values of 1 or 2. Looking to improve upon this in the future.
-(int)numberOfTitleLines {
    return 1;
}

- (void)setInitialValue:(NSObject *)initialValue {
    //Calls the validateValue method to make sure it's of the right type
    [self validateValue:initialValue];
    self.initialValue = initialValue;
}

- (void)setValue:(NSObject *)value {
    //Calls the validateValue method to make sure it's of the right type
    [self validateValue:value];
    self.value = value;
}

//Overriding this function to warn users who don't implement this function in a CBFormItem subclass
-(NSObject *)value {
    NSLog(@"WARNING: This CBFormItem does not implement the value property.");
    return nil; //Figure out how to avoid this warning for formitems that don't implement this
}

//Returns a test for equality based on the formItem's name.
-(BOOL)equals:(CBFormItem *)formItem {
    return [formItem.name isEqualToString:self.name];
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


- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    _userInteractionEnabled = userInteractionEnabled;
    
    [self setSelectionStyle:_userInteractionEnabled ?
        UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone];
}

- (void)setIcon:(FAIcon)icon withColor:(UIColor *)color {
    [self setIcon:icon];
    [self setIconColor:color];
}

@end
