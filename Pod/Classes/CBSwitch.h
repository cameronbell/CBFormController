//
//  CBSwitch.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBFormItem.h"

@interface CBSwitch : CBFormItem

//The switch
@property (nonatomic, retain) IBOutlet UISwitch *theSwitch;
//Label for the on text
@property (nonatomic, retain) IBOutlet UILabel *onLabel;
//Label for the off text
@property (nonatomic, retain) IBOutlet UILabel *offLabel;
//String to use for the on state
@property (nonatomic, retain) NSString *onString;
//String to use for the fof state
@property (nonatomic, retain) NSString *offString;

//Called when the status of the switch changes
- (void)switchChanged;

@end
