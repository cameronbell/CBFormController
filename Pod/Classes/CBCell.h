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

@property (nonatomic,retain) IBOutlet UILabel *titleLabel; //All cells will have a titleLabel property that they can choose to use or not. This will prevent all subclasses from having to manually set the title if every cell in the CBCellSet uses a titleLabel
@property (nonatomic,assign) CGFloat height; //This property represents the height of the cell at the dismissed state. This property should not be dynamic under most circumstances. Cells that have different heights based on CBFormItem properties (like engaged) will have properties on their subclasses that represent those heights. The CBFormItem is responsible for telling the formTable what height the cell should be at.
@property (nonatomic,assign) CGFloat twoLineHeight; //Returns the height when the cell has a double line title.
@property (nonatomic,retain) IBOutlet UILabel *icon;

@property (nonatomic,assign) CGFloat defaultHeight; //Required method to implement in the subclass
@property (nonatomic,assign) CGFloat defaultTwoLineHeight;

-(void)setIcon:(UILabel *)icon;
-(UILabel *)icon;

-(void)configureForFormItem:(CBFormItem *)formItem;
-(void)setCustomPropertyWithObject:(NSObject *)icon forKey:(const void *)key;
-(NSObject *)getCustomPropertyWithKey:(const void *)key;

-(NSString *)cellClassStringForFormItemClass:(Class)formItemClass;

@end
