//
//  CBSwitchCell.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBSwitchCell.h"
#import "CBSwitch.h"
#import "CBFormController.h"

@implementation CBSwitchCell
@synthesize titleLabel,theSwitch,yesLabel,noLabel;


-(void)configureForFormItem:(CBSwitch *)formItem {
    [super configureForFormItem:formItem];
    
    //Set the labels for this cell
    [self.titleLabel setText:formItem.title];
    [self.yesLabel setText:formItem.onString];
    [self.noLabel setText:formItem.offString];
    
    //Switch cells are not selectable
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    //If the form is not editing then the user should not be able to flip the switch
    [self.theSwitch setUserInteractionEnabled:[formItem.formController editing]];
    
    //Set initial value
    //This initialValue of a CBSwitch is stored as an NSNumber ( 0 or 1 )
    [self.theSwitch setOn:[(NSNumber *)formItem.initialValue boolValue]];
    
    [self.theSwitch addTarget:formItem action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];

}

@end
