//
//  EGEditStudentsTableViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 08.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGEditStudentsTableViewController.h"
#import "EGStudent.h"
#import "EGEditStudentCell.h"

@interface EGEditStudentsTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray* studentsInfo;
@property (strong, nonatomic) NSMutableArray* studentsInfoLabels;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSMutableArray* editingTextFields;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@property (strong, nonatomic) UIBarButtonItem* editButton;

@end

@implementation EGEditStudentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self blurBackground];
    
    self.editingTextFields = [NSMutableArray array];
    
    self.studentsInfo = [NSMutableArray arrayWithObjects:self.student.name, self.student.surname, self.student.email, nil];
    
    self.studentsInfoLabels = [NSMutableArray arrayWithObjects:@"Name", @"Surname", @"Email", nil];
    
    if (![self.segueIdentifier isEqualToString:@"showStudentsProfile"]) {
    
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
        
        self.editButton = editButton;
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
        
        self.doneButton = doneButton;
        
        self.navigationItem.rightBarButtonItem = editButton;
        
        if (self.isEditing) {
            
            self.navigationItem.rightBarButtonItem = doneButton;
            
        }
        
    }
    
    self.navigationItem.title = @"Student profile";
    
    self.isEditing = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void) editButtonAction:(UIBarButtonItem*) sender {
    // Разрешаем редактирование содержимого текстфилдов в ячейках.
    
    self.isEditing = YES;
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    NSLog(@"editButtonAction");
    
    for (int i = 0; i < [self.studentsInfo count]; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        EGEditStudentCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [self.editingTextFields addObject:cell];
        
    }
    
    [[[self.editingTextFields objectAtIndex:0] textField] becomeFirstResponder];
    
}

- (void) doneButtonAction:(UIBarButtonItem*) sender {
    // Убираем клавиатуру и вносим изменения в БД.
    
    for (int i = 0; i < [self.studentsInfo count]; i++) {
        
        [[[self.editingTextFields objectAtIndex:i] textField] resignFirstResponder];
        
    }
    
    NSString* studentName = [[[self.editingTextFields objectAtIndex:0] textField] text];
    NSString* studentSurname = [[[self.editingTextFields objectAtIndex:1] textField] text];
    NSString* studentEmail = [[[self.editingTextFields objectAtIndex:2] textField] text];
    
    // передаем измененные данные в родительский контроллер для редактирования БД
    [self.delegate setStudentInfoWithName:studentName surname:studentSurname andEmail:studentEmail student:self.student];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* title;
    
    if (section == 1) {
        
        title = @"Student courses";
        
    }
    
    return title;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSections = 0;
    
    if ([self.student.courses count] > 0) {
        
        numberOfSections = 2;
        
    } else {
        
        numberOfSections = 1;
        
    }
    
    return numberOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        
        numberOfRows = [self.studentsInfo count]; // name, surname and email;
        
    } else {
        
        numberOfRows = [self.student.courses count];
        
    }    
    
    return numberOfRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"studentCell";
    static NSString* courseIdentifier = @"courseCell";
    
    if (indexPath.section == 0) {
    
        EGEditStudentCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.studentTextLabel.text = (NSString*)[self.studentsInfoLabels objectAtIndex:indexPath.row];
        
        cell.textField.text = (NSString*)[self.studentsInfo objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    } else {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:courseIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:courseIdentifier];
            
        }
        
        NSMutableArray* courses = (NSMutableArray*)[self.student.courses allObjects];
        
        NSString* courseName = (NSString*)[[courses objectAtIndex:indexPath.row] name];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@", indexPath.row + 1, courseName];
        
        cell.detailTextLabel.text = nil;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    }
    
    return nil;
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return self.isEditing ? YES : NO;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:[[self.editingTextFields objectAtIndex:0] textField]]) {
        
        [textField resignFirstResponder];
        
        [[[self.editingTextFields objectAtIndex:1] textField] becomeFirstResponder];
        
    } else if ([textField isEqual:[[self.editingTextFields objectAtIndex:1] textField]]) {
        
        [textField resignFirstResponder];
        
        [[[self.editingTextFields objectAtIndex:2] textField] becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
    
}

@end
