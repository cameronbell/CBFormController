//
//  CBButton.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBButton.h"
#import "CBFormController.h"

@implementation CBButton
@synthesize titleAlign = _titleAlign;
@synthesize titleColor = _titleColor;
@synthesize buttonType = _buttonType;
@synthesize save;
@synthesize validation;

-(id)initWithName:(NSString *)name {
    if (self = [super initWithName:name]) {
        
        //Buttons should default to enabled when the form is not in editing mode
        [self setEnabledWhenNotEditing:YES];
        
    }
    return self;
}

-(CBFormItemType)type {
    return CBFormItemTypeButton;
}

-(void)configureCell:(CBCell *)cell {
    [super configure];
    [self.titleLabel setTextAlignment:self.titleAlign];
    [self.titleLabel setTextColor:self.titleColor];
}

//If the buttonType property is set, it takes precedence over the titleAlign property
-(NSTextAlignment)titleAlign {
    //Defaults to CBButtonTypeNone == 0 so this evaluates to NO
    if (_buttonType) {
        switch (_buttonType) {
            case CBButtonTypeDelete:
            case CBButtonTypeSave:
                return NSTextAlignmentCenter;
            case CBButtonTypeContinue:
                return NSTextAlignmentRight;
            default:
                return NSTextAlignmentLeft;
                break;
        }
    }else{
        return _titleAlign;
    }
}

// The title ivar takes precedence but if no title is specified then titles are provided based on the button type if applicable.
-(NSString *)title {
    if (_title) {
        return _title;
    }else{
        switch (self.buttonType) {
            case CBButtonTypeDelete:
                return @"Delete";
            case CBButtonTypeSave:
                return @"Save";
                break;
            default:
                return @"";
                break;
        }
    }
}

-(UIColor *)titleColor {
    if (_titleColor) {
        return _titleColor;
    }else{
        switch (self.buttonType) {
            case CBButtonTypeDelete:
                return COLOUR_ALERT_RED;
            default:
                return APPLE_BLUE;
                break;
        }
    }
}

@end
