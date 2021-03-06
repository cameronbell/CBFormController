//
//  CBAutoComplete.h
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import "CBFormController.h"
#import <MLPAutoCompleteTextField/MLPAutoCompleteTextField.h>


@interface CBAutoComplete : CBFormItem <MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>

// Initializer
// Contains selectorString so that the user doesn't forget to set
// initialValue before the selectorString
- (id)initWithName:(NSString *)name withSelectorString:(NSString *)selectorString;

@property (nonatomic,retain) NSString *selectorString;

@property (nonatomic, copy) NSArray* (^getAutoCompletions)(NSString *queryString);

@property (nonatomic, copy) void (^save)(NSObject *value);
@property (nonatomic, copy) BOOL (^validation)(NSObject *value);

-(void)clear;
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void(^)(NSArray *suggestions))handler;
@end
