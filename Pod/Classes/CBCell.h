//
//  CBCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <UIKit/UIKit.h>

@class CBFormItem;

@protocol CBCellCategoryProtocol <NSObject>

@optional
//This function call gives any category on this CBCell an opportunity to customize the cell.
-(void)configureAddonsForFormItem:(CBFormItem *)formItem;

@end

@interface CBCell : UITableViewCell <CBCellCategoryProtocol>

-(void)configureForFormItem:(CBFormItem *)formItem;
-(void)setCustomPropertyWithObject:(NSObject *)icon forKey:(const void *)key;
-(NSObject *)getCustomPropertyWithKey:(const void *)key;
@end
