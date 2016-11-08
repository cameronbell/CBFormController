//
//  CBViewCell.m
//  Pods
//
//  Created by Cameron Bell on 2016-11-07.
//
//

#import "CBViewCell.h"

@implementation CBViewCell

-(void)configureForFormItem:(CBText *)formItem {
    
    [super configureForFormItem:formItem];
 
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}


@end
