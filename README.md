# LibraryBookTracker_iOS
The SWAG committee is looking for a way to track who has which book from our library. The goal of this exercise is to create a simple app that connects to a web server and performs a GET, a POST, and a PUT. (Also DELETE)

## Organization 
1) Commenting System
   1.a Variable, method names
   1.b Pragma mark Organization
2) Screens
  1.a Screen 1
  1.b Screen 2
  1.c Screen 3
  1.d Screen 4
3) F.A.Q

### 1 - Commenting System

## 1.a Variable, method names
Custom methods and variables labeled by what type are
Example:
A UILabel that is meant to show the book's title
--> UILabel *labelBookTitle

An IBaction that cancels the screen
--> -(IBAction)BarButtonItemCancel:(id)sender;

A string that contains the current book ID
--> NSString *stringBookID

A method that uses HTTP put to "put" a name
-(void)methodPut:(NSString *)stringNameOfPersonChecking Out

## 1.b Pragma mark organization
All classes use the following pragma division to organize methods:
#pragma mark - View Controller Lifecycle Methods
#pragma mark - Data source Methods
#pragma mark - Delegate Methods
#pragma mark - Storyboard Segue Methods
#pragma mark - IBAction Methods
#pragma mark - Social Media Connectivity Methods
#pragma mark - API Connectivity Methods

Not all classes may have all pragma marks, but they are all organized in this order

### 2 - Screens
The screens are divided into their own respective folders for easier readibility

## 1.a: Screen 1 - Lists Books
- Tableview controller that lists the all book's author and title from the connected API

## 1.b: Screen 2 - Gives Books Details
- At the selection of a tableview row, this view presents the book's details and gives the user the ability to edit the book, checkout the book, delete the book, or share the book on facebook/ twitter

## 1.c: Screen 3 - Adds new books
- If the user decides to add a new book from screen 1, this view is presented

## 1.d: Screen 4 - Edit Current Book
- If the user decides to edit a book from screen 2, this view is presented

### 3 - F.A.Q

##Screen 3 and 4 look pretty identical.. why didn't you just use the same view and class?
Answer: 
If someone wants to edit screen 3 or 4 in the future, it would be be better to keep them seperate so they can be added their respective features.

##I noticed you placed the textFieldDelegates in "UIViewController+textFieldDelegates" .. why is that?
Answer:
Screen 3 and screen 4 both require their last textview to be moved up on iphone 3.5" screens. Instead of writing the code in their respective classes, I united them so they would be easier to edit/maintain in the future. This can easily be overridden by placing the delegates back in Screen 1 or 2's view controller and removing "UIViewController+textFieldDelegates" header










