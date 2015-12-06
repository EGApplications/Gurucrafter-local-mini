//
//  EGDataManager.m
//  CoreData #41-44
//
//  Created by Евгений Глухов on 03.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGDataManager.h"
#import "EGStudent.h"

// Все имена
static NSString* allNames[] = {
    
    @"Robert", @"David", @"Jack", @"John", @"Vince", @"James", @"Anthony", @"Tony", @"Patrick", @"Tom", @"Brad", @"Finn", @"Fred", @"Wes", @"Sam", @"Steve", @"Bruce", @"Chris", @"Bobby", @"Terry", @"Jeff", @"Sterling", @"Lisa", @"Joanna", @"Kira", @"Annie", @"Monica", @"Rebecca", @"Jenny", @"Sandra", @"Nicole", @"Victoria", @"Mary", @"Marina", @"Vanessa", @"Christie", @"Anna", @"Nina", @"Polina", @"Klara",
    // Объединение с женскими (пол пока не важен)
    @"Lisa", @"Joanna", @"Kira", @"Annie", @"Monica", @"Rebecca", @"Jenny", @"Sandra", @"Nicole", @"Victoria", @"Mary", @"Marina", @"Vanessa", @"Christie", @"Anna", @"Nina", @"Polina", @"Klara"
};

// Женские имена
static NSString* femaleNames[] = {
    
    @"Lisa", @"Joanna", @"Kira", @"Annie", @"Monica", @"Rebecca", @"Jenny", @"Sandra", @"Nicole", @"Victoria", @"Mary", @"Marina", @"Vanessa", @"Christie", @"Anna", @"Nina", @"Polina", @"Klara"
    
};

static NSString* surnames[] = {
    
    @"De Niro", @"Beckham", @"Travolta", @"Monaghan", @"Bond", @"Hopkins", @"Stark", @"Swasey", @"Hanks", @"Pitt", @"Brown", @"Durst", @"Borland", @"Rivers", @"Rogers", @"Willis", @"Hamswort", @"Labonte", @"O`Quinn", @"Bridges", @"Marlen", @"Freeman", @"Ford", @"Allen", @"Norton", @"Catch", @"Wildmore", @"Davidson", @"Will", @"Potter", @"Wesley", @"Parker", @"Marsh", @"Broflovski", @"Cartman", @"Linder", @"Walker", @"Diesel", @"McFly"
    
};

static NSString* courses[] = {
  
    // for property course.name
    
    @"iOS Dev Course", @"Web Design", @"Fundamental Coding", @"Game Design", @"Web Dynamic Course", @"Coding Site Course"
    
};

static NSString* subjects[] = {
    
    // for property course.subject
    
    @"Objective-C & Swift", @"HTML & CSS", @"C, C++ & C Sharp", @"Unity 3D", @"JavaScript & JQuery", @"PHP & MySQL"
    
};

// массивы для учителей
static NSString* teachersNames[] = {
    
    @"Alex", @"Steve", @"Stephen", @"Gabe", @"Tony", @"Ray"
    
};

static NSString* teachersSurnames[] = {
    
    @"Skutarenko", @"Rogers", @"Hawking", @"Newell", @"Stark", @"Wenderlich"
    
};

@implementation EGDataManager

+ (EGDataManager*) sharedManager {
    
    static EGDataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[EGDataManager alloc] init];
        
    });
    
    return manager;
    
}

#pragma mark - Student methods

- (void) addRandomStudents:(NSInteger) count {
    
    for (int i = 1; i < count; i++) {
        
        EGStudent* student = [NSEntityDescription insertNewObjectForEntityForName:@"EGStudent" inManagedObjectContext:self.managedObjectContext];
        
        student.name = [NSString stringWithFormat:@"%@", allNames[arc4random_uniform(58)]];
        
        student.surname = [NSString stringWithFormat:@"%@", surnames[arc4random_uniform(39)]];
        
        student.email = [NSString stringWithFormat:@"%@_%@@gmail.com", student.name, student.surname];
        
        // сохранили студента в БД.
        [student.managedObjectContext save:nil];
        
    }
    
}

- (void) addStudent:(id) student {
    
    if ([student isKindOfClass:[EGStudent class]]) {
        
        EGStudent* studentToAdd = (EGStudent*) student;
        
        EGStudent* newStudent = [NSEntityDescription insertNewObjectForEntityForName:@"EGStudent" inManagedObjectContext:self.managedObjectContext];
        
        newStudent.name = studentToAdd.name;
        
        newStudent.surname = studentToAdd.surname;
        
        newStudent.email = studentToAdd.email;
        
        [newStudent.managedObjectContext save:nil];
        
        NSLog(@"Добавили студента в БД");
        
    }
    
}

- (void) deleteAllStudents {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EGStudent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray* allStudents = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (EGStudent* student in allStudents) {
        
        [self.managedObjectContext deleteObject:student];
        
    }
    
    [self.managedObjectContext save:nil];
    
}

- (void) deleteStudent:(id) student {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EGStudent" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    if ([student isKindOfClass:[EGStudent class]]) {
        
        EGStudent* studentToDelete = (EGStudent*) student;
        
        [self.managedObjectContext deleteObject:studentToDelete];
        
        NSLog(@"Удаление студента");
        
    }
    
    [self.managedObjectContext save:nil];
    
}

#pragma mark - Courses methods

- (void) addAllCourses {
    
    // count максимум 6, так как у нас 6 курсов
    
//    @"iOS Dev Course", @"Web Design", @"Fundamental Coding", @"Game Design", @"Web Dynamic Course", @"Codecademy Course"
    
    // заполнить метод всеми курсами из массива courses вверху, выставить определенный предмет, определенную отрасль. Преподавателя назначим вручную. Студентов рандомно раскидаем по курсам.
    
    // когда из приложения создаем курс, нужен отдельный контроллер с динамической таблицей, чтобы заполнить описание курса!
    
    for (int i = 1; i <= 6; i++) {
        
        EGCourse* course = [NSEntityDescription insertNewObjectForEntityForName:@"EGCourse" inManagedObjectContext:self.managedObjectContext];
        
        course.name = [NSString stringWithFormat:@"%@", courses[i-1]]; // По порядку вписываем курсы
        course.subject = [NSString stringWithFormat:@"%@", subjects[i-1]];
        course.branch = @"Programming";
        
        // сохранили курс в БД.
        [course.managedObjectContext save:nil];
        
    }
    
    
}

- (void) deleteAllCourses {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EGCourse" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray* allCourses = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (EGCourse* course in allCourses) {
        
        [self.managedObjectContext deleteObject:course];
        
    }
    
    [self.managedObjectContext save:nil];
    
}

#pragma mark - Teachers methods

- (void) addTeachers {
    
    for (int i = 1; i <= 6; i++) {
        
        EGTeacher* teacher = [NSEntityDescription insertNewObjectForEntityForName:@"EGTeacher" inManagedObjectContext:self.managedObjectContext];
        
        teacher.name = [NSString stringWithFormat:@"%@", teachersNames[i-1]]; // По порядку вписываем имена и фамилии преподов
        teacher.surname = [NSString stringWithFormat:@"%@", teachersSurnames[i-1]];
        
        
        
        // Сами назначили предметы преподавания учителям.
        if (i < 3) {
            
            teacher.branch = @"Mobile";
            
        } else {
            
            teacher.branch = @"Design";
            
        }
        
        NSLog(@"TEACHER: name - %@, surname - %@, branch - %@", teacher.name, teacher.surname, teacher.branch);
        
        // На курсы ставим преподов вручную
        
        // сохранили препода в БД.
        [teacher.managedObjectContext save:nil];
        
    }
    
}

- (void) deleteAllTeachers {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"EGTeacher" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSArray* allTeachers = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    for (EGTeacher* teacher in allTeachers) {
        
        [self.managedObjectContext deleteObject:teacher];
        
    }
    
    [self.managedObjectContext save:nil];
    
}

// Нужен метод для очистки БД!!!!!!!!!!!!!!!!!!!!!!!!!!!

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "EG.CoreData__41_44" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData__41_44" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData__41_44.sqlite"];
    NSError *error = nil;
//    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        // Пересоздаем файл базы данных, если были изменены сущности!!!
        
//        Если мы по ходу работы захотим добавить attribute или убрать из Entities, то нам при запуске выдаст ошибку, т.к. изначально созданный файл под данное приложение (база данных) не будет соответствовать измененному. Нужно будет пересоздать файл базы данных, что мы и делаем с помощью следующих двух строк!
        
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
//        // Report any error we got.
//        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
//        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
//        dict[NSUnderlyingErrorKey] = error;
//        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
//        // Replace this with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
