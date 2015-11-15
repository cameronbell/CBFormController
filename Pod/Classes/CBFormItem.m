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

//Using the address of this char as a key for the associated object created for the custom property
static char iconKey;

@implementation CBCell
@synthesize cellSet = _cellSet;
@synthesize height = _height;

- (void)setIcon:(UILabel *)icon {
    [self setCustomPropertyWithObject:icon forKey:&iconKey];
}

- (UILabel *)icon {
    return (UILabel *)[self getCustomPropertyWithKey:&iconKey];
}

-(void)configureAddonsForFormItem:(CBText *)formItem {
    
    NSNumber *iconInteger = [formItem.addOns objectForKey:@"CBCellSet1_icon"];
    if (iconInteger) {
        self.icon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        [self.icon setTextColor:[formItem.addOns objectForKey:@"CBCellSet1_icon_color"]];
        NSString *string = [NSString fontAwesomeIconStringForEnum:[iconInteger integerValue]];
        [self.icon setText:string];
        
    }else {
        [self.icon setText:@""];
    }
}

-(void)configureForFormItem:(CBFormItem *)formItem {
    
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

- (void)awakeFromNib {
    // Initialization code
}

//If the subclass doesn't implement this function then return the default for the Cell Set
-(CGFloat)height {
    return self.cellSet.defaultHeight;
}

-(CGFloat)twoLineHeight {
    return self.cellSet.defaultTwoLineHeight;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setCustomPropertyWithObject:(NSObject *)icon forKey:(const void *)key {
    objc_setAssociatedObject(self, key,
                             icon, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(NSObject *)getCustomPropertyWithKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

-(CGFloat)defaultHeight {
    return 45;
}

-(CGFloat)defaultTwoLineHeight {
    return 70;
}

-(NSString *)cellClassStringForFormItemClass:(Class)formItemClass {
    
    //Remove the CB prefix from the formItemClass string and fail if it doesn't have that prefix.
    NSString *classString = NSStringFromClass(formItemClass);
    NSString *noprefixClassString = [NSStringFromClass(formItemClass) copy];
    if ([classString hasPrefix:@"CB"]){
        noprefixClassString = [classString substringFromIndex:[@"CB" length]];
    }else{
        NSAssert(NO, @"All FormItem classes should have CBPrefix.");
    }
    
    //Return the name of the cell as the concatenation of the name of this CBCellSet subclass and the name of the CBFormItemClass without the CB prefix.
    return [NSString stringWithFormat:@"%@%@",NSStringFromClass([self class]),noprefixClassString];
    
}

@end
