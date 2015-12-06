//
//  EGSignTeacherViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 29.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGSignTeacherViewController.h"
#import "EGTeacher.h"
#import "EGSignStudentCell.h"

@interface EGSignTeacherViewController ()

@end

@implementation EGSignTeacherViewController
@synthesize fetchedResultsController = _fetchedResultsController;

// Отображение преподов для их подписания на ведение курса

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
    EGTeacher* teacher = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    if ([self.course.teacher isEqual:teacher]) {
        // Если есть препод, удаляем его из курса.
        
        [teacher removeCoursesObject:self.course];
        
        [teacher.managedObjectContext save:nil];
        
        // нету действующего препода
        [self.delegate courseTeacher:nil];
        
    } else {
        
        [teacher addCoursesObject:self.course];
        
        [teacher.managedObjectContext save:nil];
        
        // сообщили делегату, кто теперь препод курса.
        [self.delegate courseTeacher:teacher];
        
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
    
    EGTeacher* teacher = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    EGSignStudentCell* teacherCell = (EGSignStudentCell*)cell;
    
    [teacherCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    teacherCell.initials.text = [NSString stringWithFormat:@"%ld. %@ %@", indexPath.row + 1, teacher.name, teacher.surname];
    
    if ([self.course.teacher isEqual:teacher]) {
        // Если на курс уже подписан такой студент, то ставим картинку - галка
        
        teacherCell.signStatus.image = [UIImage imageNamed:@"Yes-icon_32_32@2x.png"];
        
    } else {
        
        teacherCell.signStatus.image = [UIImage imageNamed:@"No-icon_32_32@2x.png"];
        
    }
    
    teacherCell.backgroundColor = [UIColor clearColor];
    teacherCell.backgroundView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController // геттер fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EGTeacher" inManagedObjectContext:self.managedObjectContext];
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
