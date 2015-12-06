//
//  EGTeacherProfileTableViewController.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 01.12.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGTeachersTableViewController.h"
#import "EGTeacher.h"

@protocol EGTeacherInfoDelegate <NSObject>
// Протокол для изменения данных о преподавателе и последующей отправки изменений в EGTeachersTableViewController

- (void) setTeachersInfoWithName:(NSString*) name surname:(NSString*) surname andBranch:(NSString*) branch teacher:(EGTeacher*) teacher;

@end

@interface EGTeacherProfileTableViewController : UITableViewController

@property (strong, nonatomic) EGTeacher* teacher;
@property (weak, nonatomic) id <EGTeacherInfoDelegate> delegate;

@end
