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
    
    /*
    switch (formItem.type) {
        case DDVCText:{
            
            NSInteger count = [self numberOfTitleLinesForFormItem:formItem];
            if (count == 2) {
                return 70;
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            
            
            break;}
        case DDVCFAQ:{
            NSString *question = [[self faqForIndexPath:indexPath] question];
            CGSize questionSize = [question sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]
                                       constrainedToSize:CGSizeMake(QUESTION_W, 9999)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            
            
            int questionSizeAdjusted = questionSize.height + FAQ_QUESTION_BOTTOM_PADDING;
            
            if (questionSizeAdjusted < FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT) {
                questionSizeAdjusted = FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            
            if ([formItem isEngaged]) {
                return questionSizeAdjusted + [[formItem.data objectForKey:@"answerHeight"]floatValue]+FAQ_ANSWER_BOTTOM_PADDING;
            }else{
                return questionSizeAdjusted;
            }
            break;}
        case DDVCButton:{
            
            if ([[formItem.data objectForKey:@"height"] intValue]) {
                return [[formItem.data objectForKey:@"height"] intValue];
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;}
        case DDVCSwitch:{
            NSInteger count = [self numberOfTitleLinesForFormItem:formItem];
            if (count == 4) {
                return 120;
            }else if (count == 2) {
                return 70;
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;}
        case DDVCDate:{
            if ([formItem isEngaged]) {
                if (IOS7) {
                    return 210;
                }else{
                    return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
                }
                
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;
        }
        case DDVCDoseCell: {
            return 86;//66;
            break;
        }
        case DDVCPicker: {
            if ([formItem isEngaged] && IOS7) {
                return [[formItem.data objectForKey:@"height"] intValue];
                
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;
        }
        case DDVCComment: {
            if ([formItem isEngaged]) {
                return [[[self getHeightsForComment:formItem] objectAtIndex:1]floatValue];
            }else{
                return [[[self getHeightsForComment:formItem] objectAtIndex:0]floatValue];
            }
            break;
        }
        case DDVCAutoComplete: {
            
            NSInteger count = [self numberOfTitleLinesForFormItem:formItem];
            if (count == 2) {
                return 70;
            }else{
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }
            break;
        }
        case DDVCCaption: {
            return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT*1.5;
            break;
        }
        case DDVCSegmentedControl: {
            
            if (IOS7) {
                return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            }else{
                return 60;
            }
            
            break;
        }
        default:
            return FORM_CONTROLLER_DEFAULT_FIELD_HEIGHT;
            break;
    }
     
     */
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
    
    
    
    /*
    DDVCCell *returnCell;
    switch (formItem.type) {
        case DDVCButton: {
            DDVCButtonCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCButtonCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCButtonCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCButtonCell class]]) {
                    cell = (DDVCButtonCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            returnCell = cell;
            break;
        }
        case DDVCText: {
            
            
            DDVCTextCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCTextCell"];
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCTextCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCTextCell class]]) {
                    cell = (DDVCTextCell*) currentObject;
                    break;
                }
            }
            
            [cell.textField setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.textField setUserInteractionEnabled:NO];
            [cell.textField setDelegate:self];
            [cell.textField setTag:[self menuOffsetForIndexPath:indexPath]];
            
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.textField setText:initialValue];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCFAQ: {
            DDVCFAQCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCFAQCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCFAQCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCFAQCell class]]) {
                    cell = (DDVCFAQCell*) currentObject;
                    break;
                }
            }
            
            
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            
            NSString *question = [[self faqForIndexPath:indexPath] question];
            NSString *answer = [[self faqForIndexPath:indexPath] answer];
            
            CGSize questionSize = [question sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]
                                       constrainedToSize:CGSizeMake(QUESTION_W, 9999)
                                           lineBreakMode:NSLineBreakByWordWrapping];
            
            
            int questionSizeAdjusted = questionSize.height + 20;
            
            [cell.questionTextView removeFromSuperview];
            cell.questionTextView = [[UILabel alloc]initWithFrame:CGRectMake(QUESTION_X, QUESTION_VERT_MARGIN, QUESTION_W,questionSizeAdjusted)];
            
            [cell.questionTextView setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:17.0]];
            [cell addSubview:cell.questionTextView];
            [cell.questionTextView setUserInteractionEnabled:NO];
            [cell.questionTextView setText:question];
            [cell.questionTextView setBackgroundColor:[UIColor clearColor]];
            [cell.questionTextView setLineBreakMode:NSLineBreakByWordWrapping];
            [cell.questionTextView setNumberOfLines:0];
            int questionHeightTotal = questionSizeAdjusted + QUESTION_VERT_MARGIN;
            [formItem.data setObject:NUMINT(questionHeightTotal) forKey:@"questionHeight"];
            [formItem.data setObject:NUMINT(0) forKey:@"answerHeight"];
            
            [cell.answerWebView removeFromSuperview];
            
            cell.answerWebView = [[UIWebView alloc]initWithFrame:CGRectZero];
            
            //TODO: This should be YES to enable links but there are some details I don't have the time to work out right now. Double tapping...
            [cell.answerWebView setUserInteractionEnabled:NO];
            
            //cell.answerWebView = [[UIWebView alloc]initWithFrame:CGRectMake(DDVC_FAQ_ANSWER_LEFT_INSET, questionSizeAdjusted, 280,0)];
            
            [cell.answerWebView setFrame:CGRectMake(DDVC_FAQ_ANSWER_LEFT_INSET, questionSizeAdjusted, 280,0)];
            
            NSString *helvetica = @"<body style=\"font-family:HelveticaNeue-Light;font-size:17px;\">";
            //NSString *content =[NSString stringWithFormat:@"<html><body style='background-color: transparent; width: 280px; margin: 0; padding: 0;'><div id='ContentDiv'>%@</div></body></html>",answer];
            
            NSString *fontedString = [[helvetica stringByAppendingString:answer] stringByAppendingString:@"</body>"];
            
            [cell.answerWebView setDelegate:self];
            [cell.answerWebView setTag:[self menuOffsetForIndexPath:indexPath]];
            
            //[cell.answerWebView.scrollView setContentInset:UIEdgeInsetsMake(0,DDVC_FAQ_ANSWER_LEFT_INSET, 0, 0)];
            [cell.answerWebView setBackgroundColor:[UIColor clearColor]];
            [cell.answerWebView setOpaque:NO];
            [cell.answerWebView loadHTMLString:fontedString baseURL:nil];
            [cell.answerWebView.scrollView setScrollEnabled:NO];
            [cell setClipsToBounds:YES];
            [cell addSubview:cell.answerWebView];
            
            
            returnCell = cell;
            
            break;
        }
        case DDVCDate: {
            DATE_FORMATTER
            DDVCDateCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCDateCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCDateCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCDateCell class]]) {
                    cell = (DDVCDateCell*) currentObject;
                    break;
                }
            }
            
            [cell.fieldLabel setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.fieldLabel setUserInteractionEnabled:NO];
            
            if (IOS7) {
                [cell.datePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
                [cell.datePicker setTag:[self menuOffsetForIndexPath:indexPath]];
            }else{
                [cell.datePicker removeFromSuperview];
                [self.iOS6DatePicker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
                [self.iOS6DatePicker setTag:[self menuOffsetForIndexPath:indexPath]];
                
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            
            //Set default date
            //[cell.fieldLabel setText:[dF stringFromDate:[NSDate date]]];
            //[formItem.data setObject:[NSDate date] forKey:@"date"];
            
            //Set initial value
            NSDate *initialValue = (NSDate *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                
                if (IOS7) {
                    [cell.datePicker setDate:initialValue];
                }else{
                    [self.iOS6DatePicker setDate:initialValue];
                }
                
                [cell.fieldLabel setText:[dF stringFromDate:initialValue]];
                [formItem.data setObject:initialValue forKey:@"date"];
            }
            
            
            returnCell = cell;
            break;
        }
        case DDVCSwitch: {
            DDVCSwitchCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCSwitchCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCSwitchCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCSwitchCell class]]) {
                    cell = (DDVCSwitchCell*) currentObject;
                    break;
                }
            }
            
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            if (IOS7) {
                [cell.yesLabel setText:GLS(@"YES")];
                [cell.noLabel setText:GLS(@"NO")];
            }else{
                [cell.yesLabel removeFromSuperview];
                [cell.noLabel removeFromSuperview];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            //[_fields insertObject:cell.theSwitch atIndex:menuOffset];
            
            //Set initial value
            NSNumber *initialValue = (NSNumber *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.theSwitch setOn:[initialValue boolValue]];
            }
            
            
            
            returnCell = cell;
            break;
        }
        case DDVCPicker: {
            
            
            DDVCPickerCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCPickerCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCPickerCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCPickerCell class]]) {
                    cell = (DDVCPickerCell*) currentObject;
                    break;
                }
            }
            
            [cell.pickerField setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.pickerField setUserInteractionEnabled:NO];
            //[cell.pickerButton setTag:[self menuOffsetForIndexPath:indexPath]];
            //[cell.pickerButton setUserInteractionEnabled:NO];
            
            //
            CGFloat f = 180;
            [formItem.data setObject:NUMINT(f) forKey:@"height"];
            if (IOS7) {
                //[cell.picker addTarget:self action:@selector(picker:) forControlEvents:UIControlEventValueChanged];
                [cell.picker setTag:[self menuOffsetForIndexPath:indexPath]];
                
                [cell.picker setDelegate:self];
                [cell.picker setDataSource:self];
                
            }else{
                [cell.picker removeFromSuperview];
                //[self.iOS6Picker addTarget:self action:@selector(datePicker:) forControlEvents:UIControlEventValueChanged];
                [self.iOS6Picker setTag:[self menuOffsetForIndexPath:indexPath]];
                [self.iOS6Picker setDelegate:self];
                [self.iOS6Picker setDataSource:self];
                
            }
            
            //This needs to be called before setSelectedString can be called.
            [formItem setCell:cell];
            
            //Set initial value
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [self setSelectedString:initialValue forPickerItem:formItem.name];
            }
            
            
            
            returnCell = cell;
            break;
        }
        case DDVCComment: {
            DDVCCommentCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCCommentCell"];
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCCommentCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCCommentCell class]]) {
                    cell = (DDVCCommentCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            [cell.textView setUserInteractionEnabled:NO];
            [cell.textView setTag:[self menuOffsetForIndexPath:indexPath]];
            [cell.textView setDelegate:self];
            [cell.donelabel setHidden:YES];
            
            [cell.textView setPlaceholder:@"Comments"];
            
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.textView setText:initialValue];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCAutoComplete: {
            DDVCAutoCompleteCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCAutoComplete"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCAutoCompleteCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCAutoCompleteCell class]]) {
                    cell = (DDVCAutoCompleteCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            [cell.autoCompleteTextField setDelegate:self];
            [cell.autoCompleteTextField setAutoCompleteDelegate:self];
            [cell.autoCompleteTextField setAutoCompleteDataSource:self];
            [cell.autoCompleteTextField setFormItem:formItem];
            [cell.autoCompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
            [cell.autoCompleteTextField registerAutoCompleteCellClass:[AutoCompleteOptionCell class] forCellReuseIdentifier:@"AutoCompleteOptionCell"];
            [cell.autoCompleteTextField setUserInteractionEnabled:NO];
            [cell.autoCompleteTextField setReverseAutoCompleteSuggestionsBoldEffect:YES];
            [cell.autoCompleteTextField setTag:[self menuOffsetForIndexPath:indexPath]];
            [cell.autoCompleteTextField setBackgroundColor:[UIColor whiteColor]];
            
            NSString *initialValue = (NSString *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.autoCompleteTextField setText:initialValue];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCCaption: {
            DDVCCaptionCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCCaptionCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCCaptionCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCCaptionCell class]]) {
                    cell = (DDVCCaptionCell*) currentObject;
                    break;
                }
            }
            
            [cell.titleLabel setText:[self titleForCellAtIndexPath:indexPath]];
            
            [self refreshCaption:formItem ForCaptionCell:cell forIndexPath:indexPath];
            
            
            
            [cell.cameraIcon setTitle:[NSString fontAwesomeIconStringForEnum:FACamera] forState:UIControlStateNormal];
            [cell.cameraIcon.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:22]];
            [cell.cameraIcon setTitleColor:COLOUR_ALERT_GREY forState:UIControlStateNormal];
            [cell.cameraIcon setUserInteractionEnabled:NO];
            
            
            returnCell = cell;
            break;
        }
        case DDVCSegmentedControl: {
            DDVCSegmentedControlCell *cell;// = [self.formTable dequeueReusableCellWithIdentifier:@"DDVCSegmentedControlCell"];
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCSegmentedControlCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCSegmentedControlCell class]]) {
                    cell = (DDVCSegmentedControlCell*) currentObject;
                    break;
                }
            }
            
            
            NSArray *segments = [self titleArrayForSegmentedControl:formItem];
            
            [cell.segmentedControl removeAllSegments];
            
            for (int i = 0; i<[segments count]; i++) {
                [cell.segmentedControl insertSegmentWithTitle:[segments objectAtIndex:i] atIndex:i animated:NO];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            NSNumber *initialValue = (NSNumber *)[self initialValueForFormItem:formItem];
            if (initialValue) {
                [cell.segmentedControl setSelectedSegmentIndex:[initialValue intValue]];
            }
            
            returnCell = cell;
            break;
        }
        case DDVCPopupPicker: {
            
            DDVCPopupPickerCell *cell;
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"DDVCPopupPickerCell" owner:self options:nil];
            
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[DDVCPopupPickerCell class]]) {
                    cell = (DDVCPopupPickerCell *) currentObject;
                    break;
                }
            }
            
            [cell.textField setPlaceholder:[self titleForCellAtIndexPath:indexPath]];
            [cell.textField setText:(NSString *)[self initialValueForFormItem:formItem]];
            [cell.textField setUserInteractionEnabled:NO];
            [formItem.data setObject:[self getItemsForPopupPickerFormItem:formItem] forKey:@"items"];
            
            returnCell = cell;
            break;
        }
        default:
            break;
    }
    [formItem setCell:returnCell];
    
    FAIcon icon = [self iconForFormItem:formItem];
    if (icon == 0) {
        [returnCell.icon setText:@""];
    }else{
        [returnCell.icon setText:[NSString fontAwesomeIconStringForEnum:icon]];
        [returnCell.icon setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:22]];
        [returnCell.icon setTextColor:COLOUR_BLUE];
    }
    
    
    for(int i = 0;i<[self.formItems count];i++) {
        FormItem *formItemI = [self.formItems objectAtIndex:i];
        if ([formItemI.cell isEqual:formItem.cell] && ![formItem isEqual:formItemI]) {
            NSLog(@"WTF");
        }
    }
    
    if (!IOS7) {
     
        UIView *backGroundView = [[UIView alloc]initWithFrame:CGRectZero];
        [backGroundView setBackgroundColor:[UIColor whiteColor]];
        [returnCell setBackgroundView:backGroundView];
    }
    
    
    
    [returnCell setClipsToBounds:YES];
    
    return returnCell;
    
     */
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
