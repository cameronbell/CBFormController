//
//  CBCellSet1Date.m
//  Pods
//
//  Created by Cameron Bell on 2015-08-11.
//
//

#import "CBCellSet1Date.h"
#import "CBDate.h"

@implementation CBCellSet1Date

-(void)configureForFormItem:(CBDate *)formItem {
    
    [super configureForFormItem:formItem];

    //Sets the placeholder of the dateField to the title which is the theme of this cell set
    [self.dateField setPlaceholder:formItem.title];
    
}

-(CGFloat)engagedHeight {
    return 210.0f;
}


@end
