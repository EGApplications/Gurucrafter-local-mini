//
//  EGStudentsTableViewController.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 31.10.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGStudentsTableViewController.h"
#import "EGEditStudentsTableViewController.h"

@interface EGStudentsTableViewController () <EGStudentInfoDelegate>

@property (strong, nonatomic) EGStudent* selectedStudent;

@end

@implementation EGStudentsTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    
    // вставил с сайта. Добавляем студента через AlertView
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Create student"
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
         
         textField.placeholder = @"Email";
         textField.keyboardType = UIKeyboardTypeEmailAddress;
         
     }];
    
    UIAlertAction *addAction = [UIAlertAction
                               actionWithTitle:@"Add student"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action)
                               {
                                   // Взаимодействие с БД внутри AddAction, так как в AlertView мы еще можем нажать Cancel и тогда никаких записей в БД не нужно будет делать.
                                   
                                   NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
                                   
                                   NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
                                   
                                   EGStudent* newStudent = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
                                   
                                   newStudent.name = [[alertController.textFields objectAtIndex:0] text];
                                   
                                   newStudent.surname = [[alertController.textFields objectAtIndex:1] text];
                                   
                                   newStudent.email = [[alertController.textFields objectAtIndex:2] text];
                                   
                                   [context save:nil];
                                   
                                   [self.tableView reloadData];
                                   
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:addAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - EGStudentInfoDelegate

- (void) setStudentInfoWithName:(NSString*) name surname:(NSString*) surname andEmail:(NSString*) email  student:(EGStudent *) student {
    
    // Здесь изменяем данные нашему студенту, изменения вносим в БД (НЕ УДАЛЯЕМ ЕГО, т.к. связи пропадут)
    
    NSLog(@"CHANGES name - %@, surname - %@, email - %@", name, surname, email);
    
    student.name = name;
    student.surname = surname;
    student.email = email;
    
    // Добавили отредактированного студента в БД
    [self.managedObjectContext save:nil];
    
    // Перезагрузили таблицу после редактирования студента
    [self.tableView reloadData];
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSLog(@"SEGUE");
    
    if ([[segue identifier] isEqualToString:@"EditStudent"]) {
        
        // Переход к контроллеру редактирования/отображения информации отдельно взятого студента.
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        EGStudent *student = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        EGEditStudentsTableViewController *vc = (EGEditStudentsTableViewController*)[segue destinationViewController];
        vc.student = student;
        vc.delegate = self;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // запоминаем кликнутого студента для дальнейшего удаления из БД или редактирования.
    self.selectedStudent = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"EditStudent" sender:indexPath];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifer = @"studentCell";
    
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
    
    EGStudent* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@ %@", indexPath.row + 1, student.name, student.surname];
    
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
