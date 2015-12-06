//
//  EGTeachersTableViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 02.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGTeachersTableViewController.h"
#import "EGTeacherProfileTableViewController.h"
#import "EGCourse.h"

@interface EGTeachersTableViewController () <EGTeacherInfoDelegate>

@property (strong, nonatomic) NSString* teachersBranch;

@end

@implementation EGTeachersTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // сделать blurEffect у учителей...
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    NSLog(@"REFRESHING");
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions 

- (void)insertNewObject:(id)sender {
    
    // вставил с сайта. Добавляем студента через AlertView
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Create teacher"
                                          message:@"Set properties"
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         
         textField.placeholder = @"Name";
         [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
         
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         
         textField.placeholder = @"Surname";
         [textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
         
     }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         
         textField.placeholder = @"Branch";
         textField.keyboardType = UIKeyboardTypeEmailAddress;
         
     }];
    
    UIAlertAction *addAction = [UIAlertAction
                                actionWithTitle:@"Add teacher"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * _Nonnull action)
                                {
                                    // Взаимодействие с БД внутри AddAction, так как в AlertView мы еще можем нажать Cancel и тогда никаких записей в БД не нужно будет делать.
                                    
                                    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
                                    
                                    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
                                    
                                    EGTeacher* newTeacher = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                                    
                                    newTeacher.name = [[alertController.textFields objectAtIndex:0] text];
                                    
                                    newTeacher.surname = [[alertController.textFields objectAtIndex:1] text];
                                    
                                    newTeacher.branch = [[alertController.textFields objectAtIndex:2] text];
                                    
                                    [context save:nil];
                                    
                                    [self.tableView reloadData];
                                    
                                }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"SEGUE");
    
    if ([[segue identifier] isEqualToString:@"showTeachersProfile"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EGTeacher *teacher = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        EGTeacherProfileTableViewController *vc = (EGTeacherProfileTableViewController*)[segue destinationViewController];
        vc.teacher = teacher;
        vc.delegate = self;
        
    }
    
}

#pragma mark - EGTeacherInfoDelegate

- (void) setTeachersInfoWithName:(NSString *)name surname:(NSString *)surname andBranch:(NSString *)branch teacher:(EGTeacher *)teacher {
    
    // Здесь изменяем данные нашему преподу, изменения вносим в БД (НЕ УДАЛЯЕМ ЕГО, т.к. связи пропадут)
    
    teacher.name = name;
    teacher.surname = surname;
    teacher.branch = branch;
    
    // Добавили отредактированного учителя в БД
    [teacher.managedObjectContext save:nil];
    
    // Перезагрузили таблицу после редактирования студента
    [self.tableView reloadData];
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"showTeachersProfile" sender:indexPath];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    
    return [sectionInfo name];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifer = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        
    }
    
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@ %@", indexPath.row + 1, teacher.name, teacher.surname];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"courses - %ld", [teacher.courses count]];
    
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    
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
    
    // ВАЖНО!!! Первый дескриптор должен быть тот, по которому идет группировка по секциям в tableView
    
    NSSortDescriptor *branchDescriptor = [[NSSortDescriptor alloc] initWithKey:@"branch" ascending:YES];
    NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *surnameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"surname" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[branchDescriptor, nameDescriptor, surnameDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    // sectionNameKeyPath - branch. Группировка преподавателей по секциям будет делаться исходя из их направления деятельности (branch)
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"branch" cacheName:nil];
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
