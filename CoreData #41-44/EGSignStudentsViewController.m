//
//  EGSignStudentsViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 29.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGSignStudentsViewController.h"
#import "EGSignStudentCell.h"
#import "EGStudent.h"

@interface EGSignStudentsViewController ()

@end

@implementation EGSignStudentsViewController
@synthesize fetchedResultsController = _fetchedResultsController;

// Отображение студентов для подписания их на курс!

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // запоминаем кликнутого студента для проверки на принадлежание курсу.
    EGStudent* student = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    // Делаем так. Если студент не подписан на курс, то при клике на него, мы будем его подписывать на курс.
    // Если студент подписан, то при клике мы будем его отписывать от курса.
    
    if ([self.course.students containsObject:student]) {
        // Если есть студент, удаляем его из курса.
        
        [student removeCoursesObject:self.course];
        
        [student.managedObjectContext save:nil];
        
        // При любом изменении количества студентов в группе, отправляем делегату сообщения
        [self.delegate courseStudents:self.course.students];
        
    } else {
        
        [student addCoursesObject:self.course];
        
        [student.managedObjectContext save:nil];
        
        [self.delegate courseStudents:self.course.students];
        
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifer = @"signStudentCell";
    
    EGSignStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        [self.tableView reloadData];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    EGStudent* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    EGSignStudentCell* studentCell = (EGSignStudentCell*)cell;
    
    [studentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    studentCell.initials.text = [NSString stringWithFormat:@"%ld. %@ %@", indexPath.row + 1, student.name, student.surname];
    
    if ([self.course.students containsObject:student]) {
       // Если на курс уже подписан такой студент, то ставим картинку - галка
        
        studentCell.signStatus.image = [UIImage imageNamed:@"Yes-icon_32_32@2x.png"];
        
    } else {
        
        studentCell.signStatus.image = [UIImage imageNamed:@"No-icon_32_32@2x.png"];
        
    }
    
    studentCell.backgroundColor = [UIColor clearColor];
    studentCell.backgroundView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController // геттер fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EGStudent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *surnameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"surname" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[nameDescriptor, surnameDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

@end
