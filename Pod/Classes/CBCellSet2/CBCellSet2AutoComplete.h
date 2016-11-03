//
//  CBCellSet2AutoComplete.h
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import <CBFormController/CBFormController.h>
#import "CBAutoCompleteCell.h"
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>

@interface CBCellSet2AutoComplete : CBAutoCompleteCell

@property (nonatomic,retain) IBOutlet MLPAutoCompleteTextField *textField;

@end
