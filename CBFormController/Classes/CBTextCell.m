//
//  CBTextCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBTextCell.h"
#import "CBText.h"
#import "CBFormController.h"

@implementation CBTextCell
@synthesize textField,textFieldWidth;


-(void)configureForFormItem:(CBText *)formItem {
    
    [super configureForFormItem:formItem];
    
    [self.textField setUserInteractionEnabled:NO];
    [self.textField setDelegate:formItem];
    [self.textField setText:(NSString *)formItem.initialValue];
    [self.textField setTag:[formItem.formController rowIndexForFormItem:formItem]];
    [self.textField addTarget:formItem action:@selector(textFieldEditingChange) forControlEvents:UIControlEventEditingChanged];
    [self.textField setKeyboardType:formItem.keyboardType];
}

@end
