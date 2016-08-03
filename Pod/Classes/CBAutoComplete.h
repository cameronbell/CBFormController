//
//  CBAutoComplete.h
//  Pods
//
//  Created by Cameron Bell on 2016-08-03.
//
//

#import "CBFormController.h"
@import MLPAutoCompleteTextField;


@interface CBAutoComplete : CBFormItem <MLPAutoCompleteTextFieldDelegate,MLPAutoCompleteTextFieldDataSource>

//The Class which the selectedObject should be a member of
@property (nonatomic,assign) Class objectClass;

@property (nonatomic, copy) NSArray* (^getAutoCompletions)(NSString *queryString);

-(void)clear;
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void(^)(NSArray *suggestions))handler;
@end
