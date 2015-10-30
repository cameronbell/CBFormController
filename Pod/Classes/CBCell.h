//
//  CBCell.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <UIKit/UIKit.h>
#import "CBCellSet.h"

@class CBFormItem;

@protocol CBCellCategoryProtocol <NSObject>

@optional
//This function call gives any category on this CBCell an opportunity to customize the cell.
-(void)configureAddonsForFormItem:(CBFormItem *)formItem;

@end

@interface CBCell : UITableViewCell <CBCellCategoryProtocol>

@property (nonatomic,retain) IBOutlet UILabel *titleLabel; //All cells will have a titleLabel property that they can choose to use or not. This will prevent all subclasses from having to manually set the title if every cell in the CBCellSet uses a titleLabel
@property (nonatomic,retain) CBCellSet *cellSet; //TODO: This doesn't need to be weak correct?
@property (nonatomic,assign) CGFloat height; //This property represents the height of the cell at the dismissed state. This property should not be dynamic under most circumstances. Cells that have different heights based on CBFormItem properties (like engaged) will have properties on their subclasses that represent those heights. The CBFormItem is responsible for telling the formTable what height the cell should be at.
@property (nonatomic,assign) CGFloat twoLineHeight; //Returns the height when the cell has a double line title.
@property (nonatomic,retain) IBOutlet UILabel *icon;

-(void)setIcon:(UILabel *)icon;
-(UILabel *)icon;

-(void)configureForFormItem:(CBFormItem *)formItem;
-(void)setCustomPropertyWithObject:(NSObject *)icon forKey:(const void *)key;
-(NSObject *)getCustomPropertyWithKey:(const void *)key;
@end
