//
//  EGEditStudentsTableViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 08.11.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import "EGStudentsTableViewController.h"
#import "EGStudent.h"

@protocol EGStudentInfoDelegate <NSObject>

// через данный метод передаем изменения в EGStudentsTableViewController

- (void) setStudentInfoWithName:(NSString*) name surname:(NSString*) surname andEmail:(NSString*) email student:(EGStudent*) student;

@end

// Класс для отображения/редактирования информации о студенте

@interface EGEditStudentsTableViewController : UITableViewController 

@property (strong, nonatomic) EGStudent* student;
@property (strong, nonatomic) NSString* segueIdentifier;
@property (weak, nonatomic) id <EGStudentInfoDelegate> delegate;

@end
