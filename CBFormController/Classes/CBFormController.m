//
//  CBFormController.m
//  CBFormController
//
//  Created by Cameron Bell on 2015-08-10.
//  Copyright (c) 2015 Cameron Bell. All rights reserved.
//

#import "CBFormController.h"




@interface CBFormController () {
    
    //Holds the array of section arrays which hold the form items
    NSMutableArray *_sectionArray;
    
    //The cell set object which provides different cell configurations and aethetics
    CBCellSet *_cellSet;
    
    //Holds the form item that is currently active
    CBFormItem *_engagedItem;
}

@end

@implementation CBFormController
@synthesize formTable = _formTable;
@synthesize editMode = _editMode;
@synthesize defaultDate = _defaultDate;
@synthesize saveSucceeded = _saveSucceeded;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        //Set defaults for ivars
        _editing = NO;
        _editMode = CBFormEditModeFree;
        
    }
    return self;
}

#pragma mark - Configuration Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Makes the formTable and ensures that it is properly setup with in the view
    [self setupTable];
    
    //Get all of the form configuration information from the subclass
    [self loadFormConfiguration];
    
    //This ensures this class gets the OS notifications about when the keyboard is shown
    [self registerForKeyboardNotifications];
    
    //Configures the navigation bar buttons
    [self setupNavigationBar];
}

-(void)viewDidAppear:(BOOL)animated {
    
    //Captures the form table's original content insets
    _originalInsets = self.formTable.contentInset;
}

-(void)setupTable {
    
    //Create the form table and set its view to the size of the
    self.formTable = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    //Set the delegate and datasource for the formtable to this class
    [self.formTable setDelegate:self];
    [self.formTable setDataSource:self];
    
    //Add the table to this view controller's view
    [self.view addSubview:self.formTable];
    
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.formTable setFrame:self.view.frame];
}

//This function calls getFormConfiguration and then sets the formitem's formcontroller property to this class
-(void)loadFormConfiguration {
    
    _sectionArray = [NSMutableArray arrayWithArray:[self getFormConfiguration]];
    
    //Ensure the formController property is set for all formItems
    //TODO: This will need to change to facilitate formItems being added.
    for (NSArray *section in _sectionArray) {
        for (CBFormItem *formItem in section) {
            formItem.formController = self;
        }
    }
}

//This function is called to collect all the necessary information from the subclass about how to build the form
-(NSArray *)getFormConfiguration {
    
    NSAssert(NO, @"This function must be overridden in the subclass.");
    
    return nil;
}

// Returns the cellSet that should be used to load the cells. Defaults to CBCellSet1.
// TODO: This should probably be done using something static unlike NSUserDefaults, perhaps a plist.
-(CBCellSet *)cellSet {
    
    if (!_cellSet) {
        _cellSet = [[CBCellSet1 alloc]init];
    }
    return _cellSet;
}

//If nothing sets the editMode property it defaults to CBFormEditModeFree mode.
-(CBFormEditMode)editMode {
    return _editMode ? _editMode : CBFormEditModeFree;
}

//This function returns whether the form is editing or not, meaning that the form is editable. The form is always either editing or not, regardless of the editMode.
-(BOOL)editing {
    
    switch ([self editMode]) {
        
        //In Frozen Mode the form is never editing
        case CBFormEditModeFrozen:
            return NO;
        
        //In Edit mode the form can be editing or not
        case CBFormEditModeEdit:
            return _editing;
            
        //In Free and Save mode, the form is always editing
        case CBFormEditModeFree:
        case CBFormEditModeSave:
            return YES;
        default:
            break;
    }
}

#pragma mark - FormItem Access Methods

//Returns an array of only the formItems flattened from the sectionArray
-(NSMutableArray *)formItems {
    NSMutableArray *formItems = [NSMutableArray array];
    for (int i = 0; i<[_sectionArray count]; i++) {
        NSMutableArray *itemArray = [_sectionArray objectAtIndex:i];
        [formItems addObjectsFromArray:itemArray];
    }
    return formItems;
}

//Returns a formitem found by name
-(CBFormItem *)formItem:(NSString *)name {
    for (CBFormItem *formItem in [self formItems]) {
        if ([formItem.name isEqualToString:name]) {
            return formItem;
        }
    }
    return nil;
}

//Returns the formitem at a given indexPath as represented in the sectionArray
-(CBFormItem *)formItemForIndexPath:(NSIndexPath *)indexPath {
    return [[_sectionArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
}

//Returns the formitem at a given index in a linear list of the cells
-(CBFormItem *)formItemForRowIndex:(int)rowIndex {
    return [self.formItems objectAtIndex:rowIndex];
}

//Returns the index in the formItems array of a given formItem matched by name
-(int)rowIndexForFormItem:(CBFormItem *)formItem {
    
    int rowIndex = 0;
    for (CBFormItem *formItem in [self formItems]) {
        if ([formItem equals:formItem]) {
            return rowIndex;
        }
        rowIndex++;
    }
    
    NSAssert(NO, @"This method should always find an equivalent formitem.");
    return 0;
}

#pragma mark - Engage/Dismiss Methods

//Ensures that the keyboard delegate methods are called on this class.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    CGFloat topInset = _originalInsets.top;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(topInset, 0.0, kbSize.height, 0.0);
    self.formTable.contentInset = contentInsets;
    self.formTable.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    NSIndexPath *indexPath = [self.formTable indexPathForCell:_engagedItem.cell];
    
    CGRect cellRect = [self.formTable rectForRowAtIndexPath:indexPath];
    cellRect = CGRectMake(cellRect.origin.x, cellRect.origin.y+20, cellRect.size.width, cellRect.size.height);
    
    if (!CGRectContainsPoint(aRect, cellRect.origin) ) {
        [self.formTable scrollRectToVisible:cellRect animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = _originalInsets;
    self.formTable.contentInset = contentInsets;
    self.formTable.scrollIndicatorInsets = contentInsets;
}

//Calls engage on a formItem and calls dismiss on all of the other ones
-(void)engageFormItem:(CBFormItem *)formItem {
    _engagedItem = formItem;
    
    [formItem engage];
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.formItems];
    [items removeObject:formItem];
    for (int i = 0; i<[items count]; i++) {
        CBFormItem *formItem = [items objectAtIndex:i];
        if ([formItem isEngaged]) {
            [formItem dismiss];
        }
    }
}

//Dismisses a formItem
-(void)dismissFormItem:(CBFormItem*)formItem {
    [formItem dismiss];
    if ([formItem equals:_engagedItem]) {
        _engagedItem = nil;
    }
}

#pragma mark - Return Key Management

//This function and the next are responsible for deciding which formitem to engage
// next when the user taps the return key on the keyboard
-(BOOL)textFieldShouldReturnForFormItem:(CBFormItem *)formItem {
    CBFormItem *nextItem = [self getNextItemForReturnAfter:formItem];
    if (nextItem == nil) {
        [self dismissFormItem:formItem];
    }else{
        [self engageFormItem:nextItem];
    }
    return NO;
}

-(CBFormItem *)getNextItemForReturnAfter:(CBFormItem *) formItem {
    NSInteger menuOffset = [self.formItems indexOfObject:formItem];
    if ((menuOffset+1)< [self.formItems count]) {
        return  [self.formItems objectAtIndex:(menuOffset+1)];
    }else {
        return nil;
    }
}

#pragma mark - UITableView Delegate/Datasource Methods

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self tableView:tableView titleForHeaderInSection:section].length || section == 0 ? UITableViewAutomaticDimension : 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return [self tableView:tableView titleForFooterInSection:section].length ? UITableViewAutomaticDimension : 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    return [formItem height];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    for (int i = 0; i<[[_sectionArray objectAtIndex:section] count]; i++) {
        CBFormItem *formItem = [[_sectionArray objectAtIndex:section] objectAtIndex:i];
        //if (![formItem isHidden]) {
            count++;
        //}
    }
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    return [formItem cell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    //This ensures that if a FormItem is pressed while the form is not in editing mode that nothing will happen, unless the formItem's enabledWhenNotEditing property is true
    if (!([self editing] || formItem.enabledWhenNotEditing) || !formItem.userInteractionEnabled) {
        return;
    }
    
    switch (formItem.type) {
        case CBFormItemTypeText:
        case CBFormItemTypeDate:
        case CBFormItemTypeComment:
        case CBFormItemTypeAutoComplete:
        case CBFormItemTypePicker:
        case CBFormItemTypeFAQ: {
            if ([formItem isEngaged]) {
                [self dismissFormItem:formItem];
            }else{
                [self engageFormItem:formItem];
            }
            break;
        }
        case CBFormItemTypePopupPicker: {
            [formItem selected];
            break;
        }
        case CBFormItemTypeButton: {
            [formItem selected];
            break;
        }
        case CBFormItemTypeSwitch:
        case CBFormItemTypeCaption:
        default:
            break;
    }
}

#pragma mark - Navigation Bar Management Methods

-(void)setupNavigationBar {
    [self installRightBarButton];
    
    [self updateNavigationBar];
}

-(void)updateNavigationBar {
    
    //The CBFormEditModeFrozen and CBFormEditModeFree Edit modes do not require any changes to the navigation bar buttons
    //The CBFormEditModeEdit and CBFormEditModeSave modes do.
    switch ([self editMode]) {
        case CBFormEditModeFrozen:
        case CBFormEditModeFree:
            break;
        case CBFormEditModeEdit:
        case CBFormEditModeSave:
        {
            [self configureRightBarButton];
            [self configureLeftBarButton];
            break;
        }
        default:
            break;
    }
}


-(void)configureRightBarButton {
    switch ([self editMode]) {
        case CBFormEditModeEdit:{
            if ([self editing]) {
                [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
                [self.rightButton setEnabled:[self isFormEdited]];
                [self.rightButton setEnabled:YES];
            }else{
                [self.rightButton setTitle:@"Edit" forState:UIControlStateNormal];
            }
            break;
        }
        case CBFormEditModeSave:{
            [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
            [self.rightButton setEnabled:[self isFormEdited]];
            break;
        }
            
        default:
            break;
    }
}

-(void)installRightBarButton {
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(0, 12, 70, 22)];
    [self.rightButton addTarget:self action:@selector(rightButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.rightButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.rightButton setTitleColor:self.editingButtonColorDisabled forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:self.editingButtonColorActive forState:UIControlStateNormal];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem:saveBarButton animated:YES];
    
}

-(void)configureLeftBarButton {
    
    if ([self editing]) {
        if ([self isFormEdited]){
            
            if (!self.cancelButton) {
                UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
                [cancelButton setFrame:CGRectMake(0, 12, 70, 22)];
                [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
                
                [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
                [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [cancelButton setTitleColor:self.editingButtonColorDisabled forState:UIControlStateDisabled];
                [cancelButton setTitleColor:self.editingButtonColorActive forState:UIControlStateNormal];
                
                self.cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
            }
            
            [self.navigationItem setLeftBarButtonItem:self.cancelButton animated:YES];
            [self.navigationItem setHidesBackButton:YES animated:YES];
            
        }else{
            
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
            [self.navigationItem setHidesBackButton:NO animated:YES];

        }
    }else{
        [self.navigationItem setLeftBarButtonItem:nil animated:YES];
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
}

-(IBAction)rightButtonWasPressed:(id)sender {
    switch ([self editMode]) {
        case CBFormEditModeEdit:{
            if ([self editing]) {
                [self save];
            }else{
                [self beginEdit];
            }
            break;
        }
        case CBFormEditModeSave: {
            [self save];
        }
        default:
            break;
    }
}

#pragma mark - Data Methods (Save, etc...)

-(BOOL)validate {
    return YES;
}

-(BOOL)save {
    [self dismissAllFields];
    
    BOOL validationSuccess = YES;
    
    //Allows the subclass to override the validate function
    validationSuccess = [self validate];
    if (!validationSuccess)return NO;
    
    for (CBFormItem *formItem in [self formItems]) {
        validationSuccess = formItem.validate;
        if (!validationSuccess)return NO;
    }
    
    for (CBFormItem *formItem in [self formItems]) {
        [formItem saveValue];
    }
    
    [self saveData];
    
    self.editing = NO;
    [self reloadEntireForm];
    
    if (self.saveSucceeded) {
        self.saveSucceeded(self);
    }
    
    return YES;
}

// This function is called after validation is called by the full form save function but before
// refreshing the form
- (BOOL)saveData {
    return YES;
}

-(void)beginEdit {
    self.editing = YES;
    [self reloadEntireForm];
}

-(void)cancel {
    self.editing = NO;
    [self dismissAllFields];
    [self reloadEntireForm];
}

-(void)formWasEdited {
    [self updateNavigationBar];
}

#pragma mark - Utility Methods

-(BOOL)isFormEdited {
    for (CBFormItem *formItem in [self formItems]) {
        if ([formItem isEdited]) {
            return YES;
        }
    }
    return NO;
}

-(void)reloadEntireForm {
    [self eraseCells];
    [self loadFormConfiguration];
    [self.formTable reloadData];
    [self updateNavigationBar];
}

-(void)reloadFormItem:(CBFormItem *)formItem {
    
    [formItem setCell:nil];
    [formItem setEngaged:NO];
    
    NSArray *indexPaths = @[[self indexPathForFormItem:formItem]];
    
    [self.formTable reloadRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationNone];
}

//this method exists so that a subclass can erase the cells of the formitems so that calling reloadData will actually reload the cell, which is useful in the case where we want to reload the cells from their original content like the cancel button on the profile
-(void)eraseCells {
    
    for (int i = 0; i<[self.formItems count]; i++) {
        CBFormItem *formItem = [self.formItems objectAtIndex:i];
        [formItem setCell:nil];
    }
}

-(void)dismissAllFields {
    for (int i = 0; i<[self.formItems count]; i++) {
        CBFormItem *formItem = [self.formItems objectAtIndex:i];
        [formItem dismiss];
    }
}

//Tells the formTable to update it's view properties. Mainly important for updating the height of the cells.
-(void)updates {
    [self.formTable beginUpdates];
    [self.formTable endUpdates];
}

//Shows a alert view with the validation error message
-(void)showValidationErrorWithMessage:(NSString *)message {
    [[[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
}

-(NSArray *)formItemsInSection:(NSInteger)section {
    return [_sectionArray objectAtIndex:section];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSIndexPath *)indexPathForFormItem:(CBFormItem *)formItem {
    for (int i = 0; i<[_sectionArray count]; i++) {
        NSUInteger index = [[_sectionArray objectAtIndex:i] indexOfObject:formItem];
        if (index != NSNotFound) {
            return [NSIndexPath indexPathForRow:index inSection:i];
        }
    }
    return  nil;
}

// Defaults to black
- (UIColor *)editingButtonColorActive {
    return  _editingButtonColorActive ? _editingButtonColorActive : [UIColor blackColor];
}

// Defaults to light gray
- (UIColor *)editingButtonColorDisabled {
    return  _editingButtonColorDisabled ? _editingButtonColorDisabled : [UIColor lightGrayColor];
}

@end
