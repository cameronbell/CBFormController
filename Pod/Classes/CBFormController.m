//  @author Cameron Bell
//  @author Julien Guerinet
//  Copyright (c) 2015 Cameron Bell. All rights reserved.

#import "CBFormController.h"

@interface CBFormController () {
    //Holds the array of section arrays which hold the form items
    NSMutableArray *_sections;
    
    //The current section that the user is adding items to
    NSMutableArray *_currentSection; 
    
    //Holds the form item that is currently active
    CBFormItem *_engagedItem;
    
    //Keeps track of the contentInsets that the formtable loads with so that it can reset to
    //  these insets after changing them for the keyboard
    UIEdgeInsets _originalInsets;
    
    //TODO The cancel button
    UIBarButtonItem *_cancelBarButtonItem;
}

@end

@implementation CBFormController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //Set defaults for ivars
        _editing = NO;
        _mode = CBFormModeFree;
    }
    return self;
}

#pragma mark - Configuration Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Makes the formTable and ensures that it is properly setup with in the view
    [self setupTable];
    
    //Get all of the form configuration information from the subclass
    [self loadFormConfiguration];
    
    //This ensures this class gets the OS notifications about when the keyboard is shown
    [self registerForKeyboardNotifications];
    
    //Configures the navigation bar buttons
    [self setupNavigationBar];
    
}

- (void)viewDidAppear:(BOOL)animated {
    //Captures the form table's original content insets
    _originalInsets = self.formTable.contentInset;
}

//Sets up the TableView
- (void)setupTable {
    //Create the form table and set its view to the size of the
    self.formTable = [[UITableView alloc]initWithFrame:self.view.frame
                                                 style:UITableViewStyleGrouped];
    
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

- (void)loadForm {
    //Start the new list of sections
    _sections = [NSMutableArray array];
}

- (void)startSection {
    //Check if there was a current section
    if(_currentSection){
        //Close the current section
        [_sections addObject:_currentSection];
    }
    
    //Reset the current section
    _currentSection = [NSMutableArray array];
}

- (void)addFormItem:(CBFormItem *)item {
    //Check that there is a section open before adding the form item
    if(!_currentSection){
        NSAssert(NO, @"You must start a section before adding form items");
        return;
    }
    
    //Set the FormController property on it
    [item setFormController:self];
    
    //Add it to the current section array
    [_currentSection addObject:item];
}

- (void)endForm {
    //Ends the current section
    [_sections addObject:_currentSection];
    _currentSection = nil;
}

//This function returns whether the form is editing or not, meaning that the form is editable. The form is always either editing or not, regardless of the editMode.
//TODO
-(BOOL)editing {
    switch (_mode) {
        //In Frozen Mode the form is never editing
        case CBFormModeFrozen:
            return NO;
        //In Edit mode the form can be editing or not
        case CBFormModeEdit:
            return _editing;
        //In Free and Save mode, the form is always editing
        case CBFormModeFree:
        case CBFormModeSave:
            return YES;
        default:
            NSAssert(NO, @"Unknown edit mode");
            break;
    }
}

#pragma mark - FormItem Access Methods

//Returns an array of the formItems flattened from the sectionArray
- (NSMutableArray *)formItems {
    NSMutableArray *formItems = [NSMutableArray array];
   
    for(NSMutableArray *section in _sections){
        [formItems addObjectsFromArray:section];
    }
    
    return formItems;
}

- (CBFormItem *)formItem:(NSString *)name {
    for (CBFormItem *formItem in [self formItems]) {
        if ([formItem.name isEqualToString:name]) {
            return formItem;
        }
    }
    return nil;
}

- (CBFormItem *)formItemForIndexPath:(NSIndexPath *)indexPath {
    return [[_sections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
}

- (CBFormItem *)formItemForRowIndex:(int)rowIndex {
    return [self.formItems objectAtIndex:rowIndex];
}

- (int)rowIndexForFormItem:(CBFormItem *)item {
    NSMutableArray *formItems = [self formItems];
    for(int i = 0; i < [formItems count]; i ++){
        if([[formItems objectAtIndex:i] equals:item]){
            return i;
        }
    }
    
    NSAssert(NO, @"This method should always find an equivalent formitem.");
    return -1;
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

//This function and the next are responsible for deciding which formitem to engage next when the user taps the return key on the keyboard
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
    return UITableViewAutomaticDimension;
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
    return UITableViewAutomaticDimension;
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
        if (![formItem isHidden]) {
            count++;
        }
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
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem:saveBarButton animated:YES];
    
}

-(void)configureLeftBarButton {
    
    if ([self editing]) {
        if ([self isFormEdited]){
            
            if (!_cancelBarButtonItem) {
                UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
                [cancelButton setFrame:CGRectMake(0, 12, 70, 22)];
                [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
                
                [cancelButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
                [cancelButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
                [cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
                
                _cancelBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelButton];
            }
            
            [self.navigationItem setLeftBarButtonItem:_cancelBarButtonItem animated:YES];
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
    
    self.editing = NO;
    [self reloadEntireForm];
    
    if (self.saveSucceeded) {
        self.saveSucceeded(self);
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
