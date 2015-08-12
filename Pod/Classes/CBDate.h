//
//  CBDate.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBFormItem.h"
#import "CBDateCell.h"

@interface CBDate : CBFormItem

@property (nonatomic,retain) NSDateFormatter *dateFormatter;
-(IBAction)dateChanged:(id)sender;
@end
