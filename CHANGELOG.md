# Change Log

## Version 0.3.27 (2017-05-24) 
* Fixed bug where change block would not be called if original value was selected within a CBPicker

## Version 0.3.26 (2017-05-15)
* Fixed bug where clearing an AutoCompleteField would not signal the change in value

## Version 0.3.25 (2017-01-26)
* Fixed bug in CBSwitch where function not supported on iOS 9 was being used

## Version 0.3.24 (2017-01-26)
* Removed pencil icon from comment cell
* Fixed valueChanged not being called from CBAutoComplete

## Version 0.3.23 (2017-01-26)
* Fixed bug where edited would return true for 2 nil values in autocomplete

## Version 0.3.22 (2017-01-26)
* More CBDate fixes

## Version 0.3.21 (2017-01-26)
* Trying to fix the problem with differentiating between a user-set nil value and no value on the CBDate

## Version 0.3.20 (2017-01-26)
* Added method to get the raw value from a CBDate

## Version 0.3.19 (2017-01-23)
* Allowing the initialValue and value to be set if the user has given a getPickerStringForItem block

## Version 0.3.18 (2017-01-17)
* Moved the selected block on the CBDate to be called before the default value is set

## Version 0.3.17 (2017-01-17)
* Added selected block call when CBDate is engaged

## Version 0.3.15 (2017-01-15)
* Added setValueWithoutChangeEvent function to CBSwitch

## Version 0.3.14 (2017-01-12)
* Allowing CBComment, CBText, and CBPicker to accept nil values
* Removed unnecessary call to super in CBSwitch setValue

## Version 0.3.13 (2017-01-12)
* Fix for crash involving autocomplete selector string configuration
* Added support for clearButton and nil dates on CBDate

## Version 0.3.12 (2017-01-03)
* Bug fixes for 0.3.11 changes

## Version 0.3.11 (2016-12-29)
* Bug fix for CBPicker not properly configuring cell and picker
* Converted the delegate pattern for picker strings to use a block based approach

## Version 0.3.10 (2016-12-27)
* Added optional delegate pattern to get string for CBPicker items from the form controller object

## Version 0.3.9 (2016-11-20)
* CBPicker setItems now reloads picker values and clears value if no equivalent is found
* Added clear function to CBPicker
* CBFormItem - removed assertion that cellSet exists in order to get a cell

## Version 0.3.8 (2016-11-14)
* Exposed formTable constraints
* Fixed bug where formTable constraints were clashing with translated autoresizing mask constraints

## Version 0.3.7 (2016-11-14)
* Fix for bug caused by layout code that shouldn't be used when using constraints

## Version 0.3.6 (2016-11-14)
* Added constraints to formTable to solve frame change bug when endUpdates was called

## Version 0.3.5 (2016-11-13)
* Dismiss form on tap of header/footer

## Version 0.3.4 (2016-11-13)
* dismissAllFields is now public
* Bug fixes on CBDate and CBPicker
* Added viewHeight property to CBView
* Supports hiding doses by setting height to 0

## Version 0.3.3 (2016-11-10)
* Fixed the importing of FontAwesome

## Version 0.3.2
* Moved to Pods 1.0 structure
* Removed yes/no labels on CBCellSet2Switch
* CBSwitch now always calls valueChanged when not in Edit mode
* Aligned text to right in CBCellSet2Date
* setValue sets datepicker value in CBDate
* Added CBView type
* setValue now sets switch value in CBSwitch
* CBDate now always calls valueChanged when not in Edit mode
* CBButton title looks disabled when formItem is disabled

## Version 0.2.0 (2016-05-05)
* New: Added support for validation and saving code
* New: Added option to add items that are disabled to the user
* New: Added option to set the icon color

## Version 0.1.2 (2015-08-12)
* Fixed warnings

## Version 0.1.1 (2015-08-12)
* Bug Fixes

## Version 0.1.0 (2015-08-12)
* Initial Release
