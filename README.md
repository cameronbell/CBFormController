# CBFormController

[![CI Status](http://img.shields.io/travis/Cameron Bell/CBFormController.svg?style=flat)](https://travis-ci.org/Cameron Bell/CBFormController)
[![Version](https://img.shields.io/cocoapods/v/CBFormController.svg?style=flat)](http://cocoapods.org/pods/CBFormController)
[![License](https://img.shields.io/cocoapods/l/CBFormController.svg?style=flat)](http://cocoapods.org/pods/CBFormController)
[![Platform](https://img.shields.io/cocoapods/p/CBFormController.svg?style=flat)](http://cocoapods.org/pods/CBFormController)

CBFormController is a versatile, customizable, form controller for iOS, written in Obj-C.

## Installation

CBFormController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CBFormController"
```


## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Making a Form

A CBFormController is a view controller that provides a form. It does not require a xib or any view setup by the user.

To create a CBFormController, create a subclass of CBFormController.

Then override the following function to create your form by creating CBFormItems and returning them in a 2-d array of sections:

```Obj-C
-(NSArray *)getFormConfiguration {

    //Choose the way you want your form to handle saving
    [self setEditMode:CBFormEditModeEdit];

    //Create an array of sections
    NSMutableArray *sections = [[NSMutableArray alloc] init];

    //Create a Text form item
    CBText *firstName = [[CBText alloc]initWithName:@"firstName"];
    [firstName setTitle:@"First Name"];
    [firstName setIcon:[FAKFontAwesome userIconWithSize:19]];
    [firstName setInitialValue:_appDelegate.profile.firstName];
    [firstName setValidation:^BOOL(NSString *value) {
        NSString *errString = (NSString*)[Profile validateFirstName:value];
        if (errString) {
            [self showValidationErrorWithMessage:errString];
            return NO;
        }
        return YES;
    }];
    [firstName setSave:^(NSString *value) {
        _appDelegate.profile.firstName = value;
    }];

    CBText *lastName = [[CBText alloc]initWithName:@"lastName"];
    [lastName setTitle:@"Last Name"];
    [lastName setInitialValue:_appDelegate.profile.lastName];
    [lastName setSave:^(NSString *value) {
        _appDelegate.profile.lastName = value;
    }];

    //Create a picker form item
    CBPicker *gender = [[CBPicker alloc]initWithName:@"gender"];
    [gender setTitle:@"Gender"];
    [gender setInitialValue:_appDelegate.profile.gender == MALE ? GENDER_MALE : GENDER_FEMALE];
    [gender setIcon:[FAKFontAwesome transgenderIconWithSize:18]];
    [gender setItems:@[@"Male", @"Female"]];
    [gender setSave:^(NSString *value) {
        _appDelegate.profile.gender = [value isEqualToString:GENDER_MALE] ? MALE : FEMALE;
    }];

    //Create a date form item
    CBDate *birthDate = [[CBDate alloc]initWithName:@"birthdate"];
    [birthDate setTitle:@"Birthdate"];
    [birthDate setInitialValue:_appDelegate.profile.birthDate];
    [birthDate setIcon:[FAKFontAwesome calendarIconWithSize:18]];
    [birthDate setValidation:^BOOL(NSDate *value) {
        NSString *errString = (NSString*)[Profile validateBirthDate:value];
        if (errString) {
            [self showValidationErrorWithMessage:errString];
            return NO;
        }
        return YES;
    }];
    [birthDate setSave:^(NSDate *value) {
        _appDelegate.profile.birthDate = value;
    }];

    //Add the created form items to arrays containing the form items that should be grouped together
    NSMutableArray *profileSection = [[NSMutableArray alloc] initWithObjects:firstName,lastName, nil];
    NSMutableArray *genderSection = [[NSMutableArray alloc] initWithObjects:gender,birthDate, nil];

    //Add the section arrays to the sections array
    [sections addObjectsFromArray:@[profileSection, genderSection]];

    //If this form is being shown in the walkthrough, add a continue button
    if (self.editing) {
        CBButton *deleteButton = [[CBButton alloc]initWithName:@"delete"];
        [sections addObject:@[deleteButton]];
        [deleteButton setButtonType:CBButtonTypeDelete];
        [continueButton setSelect:^{
            [self delete];
        }];
    }
    return sections;
}

```

### Form Item Types

#### CBText

#### CBDate

#### CBButton
The buttonType property takes precedence over the titleAlign property.
#### CBSwitch

#### CBComment

#### CBPicker

#### CBPopupPicker

#### CBFAQ (WIP)

#### CBView (WIP)

#### CBSegmentedControl (WIP)

#### CBAutoComplete (WIP)

#### CBCaption (WIP)


### Customized Cell Sets

CBFormController allows you to install a cell set which is a collection of classes which extend the functionality of the CBFormItems and provide the aesthetic of the cells, via an .xib file for each cell type.


### Creating a New CBFormItemType

1. Create a subclass of CBFormItem
2. Import your subclass in CBFormController
3. Create a subclass of CBCell for the new type. Ex. CBTextCell
4. Implement  ```-(void)configureForFormItem:(CBText *)formItem;``` in the CBCellSubclass
5. Create a subclass of the CBCell subclass (eg. subclass of CBTextCell) titled “[name of your CBCellSet subclass][formtype enum value]” (e.g. CBCellSet2Text )
6. Override  ```-(void)configureForFormItem:(CBText *)formItem;``` in this new subclass if necessary. Make sure to call super.
7. Create an empty xib file with the same name as the second subclass.
8. Create a single uitableviewcell in the file and set it’s class to the second subclass.
9. Implement the CBFormItem’s subclass’s methods:
     * ```-(BOOL)isEdited;```
     * ```-(CBFormItemType)type;```
     * ```-(NSObject *)value;```
     * ```-(void)setInitialValue:(NSObject *)value;```
     * ```-(void)engage;```
     * ```-(void)dismiss;```
     -
10.  In isEdited remember to account for nil cases.

### Form Items with Dynamic Heights
Call ```[self updates];``` on the CBFormController when you want the height of a cell to be updated with animation.

###Creating a New CBCellSet
1. Create a subclass of CBCellSet
2. Create an instance of the subclass and set it to the cellSet property of the CBFormController
3. Implement Default height and default two line height if applicable.
4. Create cell classes titled "[NameOfSubclass][FormItemType Enum Value]” (Must have an xib with a single cell inside for each class.)



### Creating a Custom Property on CBCell From a CBCell Category
This is useful when you want all of the cells in your custom CBCellSet to have the same property. This property could be IBOutlet and can be linked to from interface builder.

1. Define a category on CBCell (Ex. CBCell+CBCellSet1)
2. Above the the implementation, define a static char called [name of your property]Key (Ex. static char iconLabelKey;)
3. In the Interface of the category, define your new property. You cannot ```@synthesize``` this property in the .m file.
4. Then manually create a properly formatted setter and getter for this property and include their declarations in the interface. (ex.  ```-(void)setIconLabel:(UILabel *)iconLabel;``` and ```-(UILabel *)iconLabel;```)
5. Implement the getter and setter as follows:

```
- (void)setIconLabel:(UILabel *)iconLabel {
    [self setCustomPropertyWithObject:iconLabel forKey:iconLabelKey];
}
```
```
- (UILabel *)iconLabel {
    return (UILabel *)[self getCustomPropertyWithKey:iconLabelKey];
}
```

6. If the property was an IBOutlet, you will now be able to connect the custom property in Interface Builder.
7. If you need to access this property in a subclass of CBCell, then ```#import``` the category in the class in which you want to access the property.






CBButton




CBDate


The form is reloaded when save/edit/cancel are pressed.




## Requirements


## Author

Cameron Bell, cameron.bell@me.com

## License

CBFormController is available under the MIT license. See the LICENSE file for more info.
