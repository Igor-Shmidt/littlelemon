import Foundation
import CoreData

extension Dish {
    class func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }

    class func updateDishes(from menu: [MenuItem], _ context: NSManagedObjectContext) async throws {
        try await withThrowingTaskGroup { [context] group in
            let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateMOC.parent = context
            privateMOC.automaticallyMergesChangesFromParent = true
            for menuItem in menu {
                let itemMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                itemMOC.parent = privateMOC
                itemMOC.automaticallyMergesChangesFromParent = true
                group.addTask {
                    let dish = await Dish.with(item: menuItem, itemMOC)


                    try save(itemMOC)
                }
            }
            try await group.waitForAll()
            try save(privateMOC)
        }
        try save(context)

        Dish.deleteAll(context, notIn: menu)
    }

    class func with(item: MenuItem,
                    _ context: NSManagedObjectContext) async -> Dish {
        await context.perform {
            do {
                let request = Dish.request()
                request.fetchLimit = 1
                request.predicate = NSPredicate(format: "title ==[c] %@", item.title)
                request.sortDescriptors = [NSSortDescriptor(key: "title",
                                                            ascending: false,
                                                            selector: #selector(NSString .localizedStandardCompare))]
                guard let results = try request.execute() as? [Dish],
                      let dish = results.first
                else { throw CancellationError() }
                
                // update values if needed
                if dish.category != item.category { dish.category = item.category }
                if dish.text != item.text { dish.text = item.text }
                if let url = item.image.flatMap(URL.init(string:)), dish.image != url {
                    dish.image = url
                }
                if let price = Float(item.price), dish.price != price {
                    dish.price = price
                }
                return dish
            } catch {
                let dish = Dish(context: context)
                dish.title = item.title
                dish.category = item.category
                dish.text = item.text
                dish.image = item.image.flatMap(URL.init(string:))
                dish.price = Float(item.price) ?? .zero
                return dish
            }
        }
    }

    class func deleteAll(_ context:NSManagedObjectContext, notIn list: [MenuItem]) {
        let request = Dish.request()
        request.predicate = NSPredicate(format: "NOT (title IN %@) ", list.map(\.title))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            guard let persistentStoreCoordinator = context.persistentStoreCoordinator else { return }
            try persistentStoreCoordinator.execute(deleteRequest, with: context)
            try save(context)

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }


    class func save(_ context: NSManagedObjectContext) throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    func formatPrice() -> String {
        String(format: "$\(price < 10 ? " " : "")%.2f", price)
    }
}
