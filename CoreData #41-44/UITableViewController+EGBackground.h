//
//  UITableViewController+EGBackground.h
//  CoreData #41-44
//
//  Created by Евгений Глухов on 03.12.15.
//  Copyright © 2015 Evgeny Glukhov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewController (EGBackground)
// Расширяем класс UITableViewController, внося во всех наследников изменение фона

// Следующая версия
// Сделать в приложении возможность для добавления некоторого количества студентов, преподов, курсов. Рандомное добавление. Указывать будет только количество. Можно сделать с помощью UICollectionView
// UICollectionView для админа

- (void) blurBackground;

@end
