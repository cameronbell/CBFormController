//
//  CBCellSet.h
//  Pods
//
//  Created by Cameron Bell on 2015-08-10.
//
//

#import <Foundation/Foundation.h>

@interface CBCellSet : NSObject

@property (nonatomic,assign) CGFloat defaultHeight; //Required method to implement in the subclass
@property (nonatomic,assign) CGFloat defaultTwoLineHeight;
-(NSString *)cellClassStringForFormItemClass:(Class)formItemClass;

@end
