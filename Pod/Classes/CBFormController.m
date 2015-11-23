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
    
    //This ensures this class gets the OS notifications about when the keyboard is shown
    [self registerForKeyboardNotifications];
    
    //Set up the left button
    self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.leftButton setFrame:CGRectMake(0, 12, 70, 22)];
    [self.leftButton addTarget:self action:@selector(leftButtonPressed)
         forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.leftButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    self.leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.leftButton];
    
    //Set up the right button
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setFrame:CGRectMake(0, 12, 70, 22)];
    [self.rightButton addTarget:self action:@selector(rightButtonPressed)
          forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.rightButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.rightButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    [self.navigationItem setRightBarButtonItem:self.rightBarButton animated:YES];
    
    [self updateNavigationBar];
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
- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

//Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
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
    
    NSIndexPath *indexPath = [self.formTable indexPathForCell:_engagedItem];
    
    CGRect cellRect = [self.formTable rectForRowAtIndexPath:indexPath];
    cellRect = CGRectMake(cellRect.origin.x, cellRect.origin.y + 20, cellRect.size.width,
                          cellRect.size.height);
    
    if (!CGRectContainsPoint(aRect, cellRect.origin)) {
        [self.formTable scrollRectToVisible:cellRect animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    UIEdgeInsets contentInsets = _originalInsets;
    self.formTable.contentInset = contentInsets;
    self.formTable.scrollIndicatorInsets = contentInsets;
}

// Engages a form item and dismisses the other ones
-(void)engageFormItem:(CBFormItem *)formItem {
    _engagedItem = formItem;
    [formItem setEngaged:YES];
    
    //Go through the form items except for this one
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.formItems];
    [items removeObject:formItem];
    
    for (CBFormItem *item in items) {
        //Dismiss them (nothing will happen if they are already dismissed)
        [item setEngaged:NO];
    }
}

// Dismisses a formItem
- (void)dismissFormItem:(CBFormItem *)formItem {
    [formItem setEngaged:NO];
    
    //Reset the engages item to nil if this is the form item we are dismissing
    if ([formItem equals:_engagedItem]) {
        _engagedItem = nil;
    }
}

#pragma mark - Return Key Management

// Engages the next form item if there is one
- (BOOL)textFieldShouldReturnForFormItem:(CBFormItem *)formItem {
    //Get the next form item
    CBFormItem *item = [self.formItems objectAtIndex:[self.formItems indexOfObject:formItem] + 1];
    
    //If there isn't one, dismiss the current form item
    if (!item) {
        [self dismissFormItem:formItem];
    }
    //If there is one, engage it
    else {
        [self engageFormItem:formItem];
    }
    return NO;
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
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int count = 0;
    
    for (int i = 0; i < [[_sections objectAtIndex:section] count]; i++) {
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
    
    //Deselect the form item
    CBFormItem *formItem = [self formItemForIndexPath:indexPath];
    
    //If the form item should not be pressed, don't continue
    if (!([self editing] || formItem.enabledWhenNotEditing) || !formItem.userInteractionEnabled) {
        return;
    }
    
    //Engage or disengage the chosen form item
    if ([formItem isSelected]) {
        [self dismissFormItem:formItem];
    }
    else {
        [self engageFormItem:formItem];
    }
}

#pragma mark - Navigation Bar Management Methods

-(void)updateNavigationBar {
    //The CBFormEditModeFrozen and CBFormEditModeFree Edit modes do not require any changes
    //  to the navigation bar buttons
    //The CBFormEditModeEdit and CBFormEditModeSave modes do.
    switch ([self mode]) {
        case CBFormModeEdit:
        case CBFormModeSave: {
            [self configureRightButton];
            [self configureLeftButton];
            break;
        }
        default:
            break;
    }
}

//Configures the left bar button
- (void)configureLeftButton {
    if ([self editing]) {
        if ([self isFormEdited]){
            [self.navigationItem setLeftBarButtonItem:self.leftBarButton animated:YES];
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

//Configures the right bar button
- (void)configureRightButton {
    switch ([self mode]) {
        case CBFormModeEdit:{
            if ([self editing]) {]
                [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
                [self.rightButton setEnabled:[self isFormEdited]];
            } else {
                [self.rightButton setTitle:@"Edit" forState:UIControlStateNormal];
            }
            break;
        }
        case CBFormModeSave:{
            [self.rightButton setTitle:@"Save" forState:UIControlStateNormal];
            [self.rightButton setEnabled:[self isFormEdited]];
            break;
        }
        default:
            break;
    }
}

- (void)leftButtonPressed {
    self.editing = NO;
    [self dismissAllFields];
    [self reloadEntireForm];
}

- (void)rightButtonPressed {
    switch ([self mode]) {
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
