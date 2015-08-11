//
//  CBCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <UIKit/UIKit.h>

@class CBFormItem;

@interface CBCell : UITableViewCell

-(void)configureForFormItem:(CBFormItem *)formItem;
-(void)setCustomPropertyWithObject:(NSObject *)icon forKey:(char)key;
-(NSObject *)getCustomPropertyWithKey:(char)key;
@end
