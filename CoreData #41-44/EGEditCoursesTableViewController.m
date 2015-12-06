//
//  EGEditCoursesTableViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 14.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGEditCoursesTableViewController.h"
#import "EGSignStudentsViewController.h"
#import "EGSignTeacherViewController.h"
#import "EGEditStudentsTableViewController.h"
#import "EGTeacher.h"
#import "EGStudent.h"
#import "EGCourse.h"
#import "EGCourseCell.h"
#import "EGButtonCell.h"
#import "EGEditStudentCell.h"

@interface EGEditCoursesTableViewController () <UITextFieldDelegate, EGCourseInfoDelegate>

@property (strong, nonatomic) NSMutableArray* studentsInfo;
@property (strong, nonatomic) NSMutableArray* courseInfo;
@property (strong, nonatomic) NSMutableArray* courseTextFields;
@property (strong, nonatomic) NSMutableArray* courseLabelInfo;
@property (assign, nonatomic) BOOL isEditing;
@property (strong, nonatomic) UIBarButtonItem* doneButton;
@property (strong, nonatomic) UIBarButtonItem* editButton;
@property (assign, nonatomic) NSInteger countForDisplayedCells;
@property (strong, nonatomic) EGStudent* selectedStudent;

@end

@implementation EGEditCoursesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* teacher;
    self.studentsInfo = [NSMutableArray array];
    self.courseTextFields = [NSMutableArray array];
    self.countForDisplayedCells = 0;
    
    [self blurBackground];
    
    if (self.course.teacher != nil) {
        
        teacher = [NSString stringWithFormat:@"%@ %@", self.course.teacher.name, self.course.teacher.surname];
        
    } else {
        
        teacher = @"Choose the Teacher";
        
    }
    
    self.courseLabelInfo = [NSMutableArray arrayWithObjects:@"Course", @"Subject", @"Branch", @"Teacher", nil];
    
    // Студенты, подписанные на курс
    self.studentsInfo = (NSMutableArray*)[self.course.students allObjects];
    
    NSLog(@"students on course - %ld", [self.studentsInfo count]);
    
    if ([self.editOrAdd isEqualToString:@"Add"]) {
        
        self.courseInfo = [NSMutableArray arrayWithObjects:@"Name of course", @"Subject", @"Branch", nil];
        
        self.isEditing = YES;
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
        
        self.navigationItem.rightBarButtonItem = doneButton;
        
    } else {
        // Edit
        
        // Просмотр описания курса + возможность редактирования информации о курсе!
        self.courseInfo = [NSMutableArray arrayWithObjects:self.course.name, self.course.subject, self.course.branch, teacher, nil];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonAction:)];
        
        self.editButton = editButton;
        
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonAction:)];
        
        self.doneButton = doneButton;
        
        self.navigationItem.rightBarButtonItem = editButton;
        
        self.navigationItem.title = @"Course description";
        
        self.isEditing = NO;
        
    }
    
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.isEditing) {
    
        // Если нажимаем back в момент добавления курса, то ничего не сохраняем.
        [[self.course managedObjectContext] deleteObject:self.course];
        
        [[self.course managedObjectContext] save:nil];
        
    }
    
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
    
    [[self.courseTextFields objectAtIndex:0] becomeFirstResponder];
    
}

- (void) doneButtonAction:(UIBarButtonItem*) sender {
    
    // Запоминаем курс, сохраняем его в БД
    [self.course setName:[[self.courseTextFields objectAtIndex:0] text]];
    
    [self.course setSubject:[[self.courseTextFields objectAtIndex:1] text]];
    
    [self.course setBranch:[[self.courseTextFields objectAtIndex:2] text]];
    
    self.isEditing = NO;
    
    [[self.course managedObjectContext] save:nil]; // сразу сохранение отредактированного курса в Кор дате
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString* header;
    
    switch (section) {
            
        case 0:
            
            header = @"COURSE INFO";
            
            break;
            
        case 1:
            
            header = @"STUDENTS ON COURSE";
            
            break;
            
        default:
            break;
    }
    
    return header;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    
    switch (section) {
            
        case 0:
            // courseName, subject, branch, teacher
            
            numberOfRows = [self.courseInfo count];
            
            break;
            
        case 1:
            
            numberOfRows = [self.studentsInfo count] + 1; // For enrollStudents button + students
            
            break;
            
        default:
            break;
    }
    
    return numberOfRows;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"studentCell";
    static NSString* buttonIdentifier = @"buttonCell";
    static NSString* courseIdentifier = @"descriptionCell";
    
    if (indexPath.section == 0) {
        // TeacherCell надо
        
        EGCourseCell* courseCell = [tableView dequeueReusableCellWithIdentifier:courseIdentifier];
        
        if (indexPath.row == 3) {
        
            [courseCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            courseCell.courseLabel.text = (NSString*)[self.courseLabelInfo objectAtIndex:indexPath.row];
            courseCell.courseTextField.text = (NSString*)[self.courseInfo objectAtIndex:indexPath.row];
            
        } else {
            
            if ([self.editOrAdd isEqualToString:@"Add"]) {
                
                courseCell.courseLabel.text = (NSString*)[self.courseLabelInfo objectAtIndex:indexPath.row];
                
                // Placeholder for textField
                [courseCell.courseTextField setPlaceholder:(NSString*)[self.courseInfo objectAtIndex:indexPath.row]];
                
                self.countForDisplayedCells++;
                
            } else {
            
                courseCell.courseLabel.text = (NSString*)[self.courseLabelInfo objectAtIndex:indexPath.row];
                courseCell.courseTextField.text = (NSString*)[self.courseInfo objectAtIndex:indexPath.row];
            
            }
            
            // При просчете ячеек ловим текстфилды в массив, с которым будем работать
            [self.courseTextFields addObject:courseCell.courseTextField];
            
        }
        
        courseCell.backgroundColor = [UIColor clearColor];
        courseCell.backgroundView.backgroundColor = [UIColor clearColor];
        
        return courseCell;
        
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        
        EGButtonCell* buttonCell = [tableView dequeueReusableCellWithIdentifier:buttonIdentifier];
        
        buttonCell.enrollStudentsLabel.text = @"Enroll Students";
        
        // После того как три первых текстфилда прогрузятся, ставим курсор на первый.
        if (self.countForDisplayedCells == 3) {
            
            [[self.courseTextFields objectAtIndex:0] becomeFirstResponder];
            
        }
        
        buttonCell.backgroundColor = [UIColor clearColor];
        buttonCell.backgroundView.backgroundColor = [UIColor clearColor];
        
        return buttonCell;
        
    } else {
        
        // Отображение подписанных студентов
        UITableViewCell* studentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!studentCell) {
            
            studentCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
            
        }
        
        [studentCell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        // indexPath.row - 1 потому что первая строка - buttonCell, а элементы нужно начинать считать с нуля!
        NSString* studentName = [(EGStudent*)[self.studentsInfo objectAtIndex:indexPath.row - 1] name];
        NSString* studentSurname = [(EGStudent*)[self.studentsInfo objectAtIndex:indexPath.row - 1] surname];
        
        studentCell.textLabel.text = [NSString stringWithFormat:@"%ld. %@ %@", indexPath.row, studentName, studentSurname];
        
        studentCell.detailTextLabel.text = nil;
        
        studentCell.backgroundColor = [UIColor clearColor];
        studentCell.backgroundView.backgroundColor = [UIColor clearColor];
        
        return studentCell;
        
    }
    
    return nil;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL result;
    
    if (indexPath.section == 1 && indexPath.row > 0) {
        
        result = YES;
        
    }
    
    return result;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EGStudent* selectedStudent = [self.studentsInfo objectAtIndex:indexPath.row - 1];
    
    // Удаляем студента с курса в БД и в массиве
    
    [selectedStudent removeCoursesObject:self.course];
    
    [selectedStudent.managedObjectContext save:nil];
    
    NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.studentsInfo];
    
    [tempArray removeObject:selectedStudent];
    
    self.studentsInfo = tempArray;
    
    // анимация удаления
    [tableView beginUpdates];
    
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [tableView endUpdates];
    
    // Перезагружем таблицу через 0.3 сек для корректного отображения нумерации студентов.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        // Course Teacher

        EGSignTeacherViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EGSignTeacherViewController"];
        
        vc.course = self.course;
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (indexPath.section == 1 && indexPath.row > 0) {
        // клик на студенте.
        
        self.selectedStudent = (EGStudent*)[self.studentsInfo objectAtIndex:indexPath.row - 1];
        
        [self performSegueWithIdentifier:@"showStudentsProfile" sender:indexPath];
        
    }
    
}

#pragma mark - EGCourseInfoDelegate

// Методы делегата для отображения выбранного учителя и подписанных на курс студентов.

- (void) courseTeacher:(EGTeacher*) teacher {
    
    NSString* courseTeacher;
    
    if (!teacher) {
        // Если препода не выбрали
        
        // Убираем то, что было в строке Teacher (последний элемент данного массива)
        [self.courseInfo removeLastObject];
        
        courseTeacher = @"Choose the Teacher";
        
        [self.courseInfo addObject:courseTeacher];
        
        [self.tableView reloadData];
        
    } else {
        
        [self.courseInfo removeLastObject];
        
        courseTeacher = [NSString stringWithFormat:@"%@ %@", teacher.name, teacher.surname];
        
        [self.courseInfo addObject:courseTeacher];
        
        [self.tableView reloadData];
        
    }
    
}

- (void) courseStudents:(NSSet*) students {
    
    // загружаем в массив новый список студентов, полученный из контроллера, где мы подписывали студентов на курс
    
    NSMutableArray* tempArray = (NSMutableArray*)[students allObjects];
    
    // Сортировка студентов, подписанных на курс.
    
    NSSortDescriptor* nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor* surnameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"surname" ascending:YES];
    
    self.studentsInfo = (NSMutableArray*)[tempArray sortedArrayUsingDescriptors:@[nameDescriptor, surnameDescriptor]];
    
    [self.tableView reloadData];
    
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"enrollStudents"]) {
        
        EGSignStudentsViewController* vc = (EGSignStudentsViewController*)segue.destinationViewController;
        
        vc.course = self.course;
        vc.delegate = self;
        
    } else if ([segue.identifier isEqualToString:@"showStudentsProfile"]) {
        
        EGEditStudentsTableViewController* vc = (EGEditStudentsTableViewController*)segue.destinationViewController;
        
        vc.student = self.selectedStudent;
        vc.segueIdentifier = segue.identifier;
        
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([self.editOrAdd isEqualToString:@"Add"]) {
        
        return YES;
        
    } else {
        // Edit mode
        
        // Edit или Done
        
        return self.isEditing ? YES : NO;
        
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:[self.courseTextFields objectAtIndex:0]]) {
        
        [textField resignFirstResponder];
        
        [[self.courseTextFields objectAtIndex:1] becomeFirstResponder];
        
    } else if ([textField isEqual:[self.courseTextFields objectAtIndex:1]]) {
        
        [textField resignFirstResponder];
        
        [[self.courseTextFields objectAtIndex:2] becomeFirstResponder];
        
    } else {
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
    
}



@end
