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

-(id)initWithName:(NSString *)name {
    if (self = [super initWithName:name]) {
        //Buttons should default to enabled when the form is not in editing mode
        [self setEnabledWhenNotEditing:YES];
    }
    return self;
}

-(void)configure {
    [super configure];
    
    [self.titleLabel setTextAlignment:self.titleAlignment];
    [self.titleLabel setTextColor:self.titleColor];
}

@end
