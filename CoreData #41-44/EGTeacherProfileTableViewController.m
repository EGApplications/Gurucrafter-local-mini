//
//  EGTeacherProfileTableViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 01.12.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGTeacherProfileTableViewController.h"
// EGCourseCell.h используем для отображения информации о преподе
#import "EGCourseCell.h"

@interface EGTeacherProfileTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray* teachersInfo;
@property (strong, nonatomic) NSMutableArray* teachersInfoLabels;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) NSMutableArray* editingTextFields;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@property (strong, nonatomic) UIBarButtonItem* editButton;

@end

@implementation EGTeacherProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self blurBackground];
    
    self.editingTextFields = [NSMutableArray array];
    
    self.teachersInfo = [NSMutableArray arrayWithObjects:self.teacher.name, self.teacher.surname, self.teacher.branch, nil];
    
    self.teachersInfoLabels = [NSMutableArray arrayWithObjects:@"Name", @"Surname", @"Branch", nil];
        
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
    
    self.editButton = editButton;
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
    
    self.doneButton = doneButton;
    
    self.navigationItem.rightBarButtonItem = editButton;
    
    if (self.isEditing) {
        
        self.navigationItem.rightBarButtonItem = doneButton;
        
    }
    
    self.navigationItem.title = @"Teachers profile";
    
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
    
    for (int i = 0; i < [self.teachersInfo count]; i++) {
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        
        EGCourseCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        [self.editingTextFields addObject:cell];
        
    }
    
    [[[self.editingTextFields objectAtIndex:0] courseTextField] becomeFirstResponder];
    
}

- (void) doneButtonAction:(UIBarButtonItem*) sender {
    // Убираем клавиатуру и вносим изменения в БД.
    
    for (int i = 0; i < [self.teachersInfo count]; i++) {
        
        [[[self.editingTextFields objectAtIndex:i] courseTextField] resignFirstResponder];
        
    }
    
    NSString* teacherName = [[[self.editingTextFields objectAtIndex:0] courseTextField] text];
    NSString* teacherSurname = [[[self.editingTextFields objectAtIndex:1] courseTextField] text];
    NSString* teacherBranch = [[[self.editingTextFields objectAtIndex:2] courseTextField] text];
    
    // передаем измененные данные контроллеру-делегату для редактирования БД
    [self.delegate setTeachersInfoWithName:teacherName surname:teacherSurname andBranch:teacherBranch teacher:self.teacher];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* title;
    
    if (section == 1) {
        
        title = @"Courses of teacher";
        
    }
    
    return title;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger numberOfSections = 0;
    
    if ([self.teacher.courses count] > 0) {
        
        numberOfSections = 2;
        
    } else {
        
        numberOfSections = 1;
        
    }
    
    return numberOfSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    if (section == 0) {
        
        numberOfRows = [self.teachersInfo count]; // name, surname and branch;
        
    } else {
        
        numberOfRows = [self.teacher.courses count];
        
    }
    
    return numberOfRows;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"descriptionCell";
    static NSString* courseIdentifier = @"courseCell";
    
    if (indexPath.section == 0) {
        
        EGCourseCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        cell.courseLabel.text = (NSString*)[self.teachersInfoLabels objectAtIndex:indexPath.row];
        
        cell.courseTextField.text = (NSString*)[self.teachersInfo objectAtIndex:indexPath.row];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        return cell;
        
    } else {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:courseIdentifier];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:courseIdentifier];
            
        }
        
        NSMutableArray* courses = (NSMutableArray*)[self.teacher.courses allObjects];
        
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
    
    if ([textField isEqual:[[self.editingTextFields objectAtIndex:0] courseTextField]]) {
        
        [textField resignFirstResponder];
        
        [[[self.editingTextFields objectAtIndex:1] courseTextField] becomeFirstResponder];
        
    } else if ([textField isEqual:[[self.editingTextFields objectAtIndex:1] courseTextField]]) {
        
        [textField resignFirstResponder];
        
        [[[self.editingTextFields objectAtIndex:2] courseTextField] becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
    
}

@end
