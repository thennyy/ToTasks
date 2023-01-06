//
//  DataManger.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/18/22.
//

import CoreData

class Image: Decodable {
  
    let name: String
    let group: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.group = dictionary["group"] as? String ?? ""
    }
}
class SendEmail {
    
    let sender: String
    let emailText: String
    let date: Date
    
    init(sender: String, emailText: String, date: Date) {
        self.sender = sender
        self.emailText = emailText
        self.date = date
    }
}
class DataManager {
    
    static let shared = DataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToTasks")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("ERROR ")
            }
        }
        
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func addItem(_ text: String, category: Category) -> Item {
       
        let item = Item(context: persistentContainer.viewContext)
        item.title = text
        item.time = Date()
        item.done = false
        item.category = category
        
        saveContext()
        
        return item
        
    }
    func addCategory(_ taskModel: TaskModel) -> Category {
        
        let localCategory = Category(context: persistentContainer.viewContext)
        localCategory.name =  taskModel.name
        localCategory.color = taskModel.color
        localCategory.image = taskModel.image
        localCategory.time = Date()
        saveContext()
        
        return localCategory 
        
    }
    func fetchTasks(_ item: TaskModel, category: Category) -> [Item] {
    
        var items = [Item]()
        let context = persistentContainer.viewContext
        
        let predicate = NSPredicate(format: "category.name", category.name!)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
       
        request.predicate = predicate
        do {
            items = try context.fetch(request)
        }catch {
            print("ERROR: TO FETCH", error.localizedDescription)
        }
        saveContext()
        
        return items
        
    }
    func fetchCategory() -> [Category] {
        var category = [Category]()
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            category = try context.fetch(request)
        }catch {
            print("DEBUG: ERROR TO FETCH ")
        }
        
        return category
    }
    func fetchItems(category: Category) -> [Item] {
        
        var items = [Item]()
        let context = persistentContainer.viewContext
        let predicate = NSPredicate(format: "category.name MATCHES %@", category.name!)
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = predicate
        
        do {
            items =  try context.fetch(request)
        }catch {
            print("Error", error)
        }
        return items
    }
    func deleteCategory(category: Category) {
        let context = persistentContainer.viewContext
        context.delete(category)
        saveContext()
    }
    func deleteItem(item: Item) {
        let context = persistentContainer.viewContext
        context.delete(item)
        saveContext()
        
    }
    func updateItem(text: String, category: Category) -> Item {
        let item = addItem(text, category: category)
       saveContext()
    
        return item
    }
    func updateItemCheck(isItemCheck: Bool, category: Category) -> Item {
        let item = Item(context: persistentContainer.viewContext)
        item.done = isItemCheck
        item.category = category
        
        saveContext()
        
        return item
    }
  
    func updateItemIsCheck(item: Item, category: Category) {

        item.setValue(item.done, forKey: "done")
        
        saveContext()
        
    }
    func checkPremiumUser(completion: @escaping(Bool) -> Void) {
        let user = Users(context: persistentContainer.viewContext)
        let premium = user.premium
        completion(premium)
    }
    func saveAlert(category: Category, selectedTime: Date) {
        
        category.setValue(selectedTime, forKey: "alarm")
        saveContext()
        
    }
}
