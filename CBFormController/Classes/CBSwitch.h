//
//  CBSwitch.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import "CBFormItem.h"

@interface CBSwitch : CBFormItem

@property (nonatomic,retain) NSString *onString;
@property (nonatomic,retain) NSString *offString;
@property (nonatomic, copy) void (^save)(NSNumber *value);
@property (nonatomic, copy) BOOL (^validation)(NSNumber *value);
@property (nonatomic, copy) void (^switchedTo)(NSNumber *value);

//This initialValue of a CBSwitch is stored as an NSNumber ( 0 or 1 )

-(void)switchChanged;

@end
