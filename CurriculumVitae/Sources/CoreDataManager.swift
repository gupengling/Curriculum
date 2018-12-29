//
//  CoreDataManager.swift
//  CurriculumVitae
//
//  Created by 顾鹏凌 on 2018/12/25.
//  Copyright © 2018 顾鹏凌. All rights reserved.
//

import UIKit
import CoreData


func kRGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}
class CoreDataManager: NSObject {
    // 单例
    static let shared = CoreDataManager()

//    // 拿到AppDelegate中创建好了的NSManagedObjectContext
//    lazy var context: NSManagedObjectContext = {
////        let context = ((UIApplication.shared.delegate) as! AppDelegate).context
//        return context
//    }()

    // 更新数据
//    private
    func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    // 增加数据
    func savePersonWith(name: String, age: Int16) {
        let person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: context) as! Person
        person.name = name
        person.age = age
        saveContext()
    }

    // 根据姓名获取数据
    func getPersonWith(name: String) -> [Person] {
        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result: [Person] = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }

    // 获取所有数据
    func getAllPerson() -> [Person] {
        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }

    // 根据姓名修改数据
    func changePersonWith(name: String, newName: String, newAge: Int16) {
        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for person in result {
                person.name = newName
                person.age = newAge
            }
        } catch {
            fatalError();
        }
        saveContext()
    }

    // 根据姓名删除数据
    func deleteWith(name: String) {
        let fetchRequest: NSFetchRequest = Person.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let result = try context.fetch(fetchRequest)
            for person in result {
                context.delete(person)
            }
        } catch {
            fatalError();
        }
        saveContext()
    }

    // 删除所有数据
    func deleteAllPerson() {
        let result = getAllPerson()
        for person in result {
            context.delete(person)
        }
        saveContext()
    }


    func saveSchoolWith(key:String, name: String) {
        let school = NSEntityDescription.insertNewObject(forEntityName: "School", into: context) as! School
        school.name = name
        school.key = key
        saveContext()
    }
    func getSchoolWith(name: String) -> [School] {
        let fetchRequest: NSFetchRequest = School.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "key == %@", name)
        do {
            let result: [School] = try context.fetch(fetchRequest)
            return result
        } catch {
            fatalError();
        }
    }
    ///////////////////////
    //MARK: lazy
    //modelURL中填写的是模型文件的名字，并且后缀填写momd
    lazy var managerObjectModel:NSManagedObjectModel = {
        let modelUrl = Bundle.main.url(forResource: "Model", withExtension: "momd")
        let managerObjectModel = NSManagedObjectModel.init(contentsOf: modelUrl!)
        return managerObjectModel!
    }()
    //懒加载持久化存储协调器NSPersistentStoreCoordinator
    //    sqliteURL是sqlite文件的路径
    //    documentDir是后面加载好了的Document路径
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let persistentStoreCoordinator = NSPersistentStoreCoordinator.init(managedObjectModel: managerObjectModel)
        let sqliteURL = documentDir.appendingPathComponent("Model.sqlite")
        let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
        var failureReason = "There was an error creating or loading the application's saved data."

        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: sqliteURL, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: Any]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as Any?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as Any?
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 6666, userInfo: dict)
            print("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return persistentStoreCoordinator
    }()

    lazy var documentDir: URL = {
        let documentDir = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first
        return documentDir!
    }()
    //懒加载NSManagedObjectContext
    lazy var context: NSManagedObjectContext = {
        let context = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
}

extension CoreDataManager {

}
