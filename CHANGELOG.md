# Change Log
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
