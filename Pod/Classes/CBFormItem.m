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

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)configure {
    [cell setSelectionStyle:[self userInteractionEnabled] ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone];
    
    //Set the titlelabel's text to the formItem's title - This may not do anything if the cell doesn't use a titleLabel.
    [self.titleLabel setText:formItem.title];
    
    [self setClipsToBounds:YES];
    
    //Makes it such that the cell cannot be highlighted by tapping when the form isn't editing, or unless the user has specific that this cell should be able to be interacted with even when the form is not editing
    if (!([formItem.formController editing] || formItem.enabledWhenNotEditing)) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    //This function call gives any category on this CBCell an opportunity to customize the cell.
    if ([self respondsToSelector:@selector(configureAddonsForFormItem:)]) {
        [self configureAddonsForFormItem:formItem];
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
