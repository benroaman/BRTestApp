//
//  TextState.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/2/25.
//

import Foundation
import CoreData

// MARK: Protocol
protocol TextCollectionState: Observable {
    var textCollection: [TextRecord] { get }
    func createRecord(_ modification: TextModifyState)
    func modifyRecord(_ modification: TextModifyState)
    func removeRecord(_ record: TextRecord)
    func toggleFavorite(_ record: TextRecord)
    func moveRecords(from source: IndexSet, to destination: Int)
}

// MARK: Actual
@Observable
final class TextCollectionStateUserDefaultsBacked: TextCollectionState {
    // MARK: Instance Variables
    private(set) var textCollection: [TextRecord]
    
    // MARK: Initializers
    init() {
        self.textCollection = TextSettings.TextRecords.current
    }
    
    // MARK: Public API
    func createRecord(_ modification: TextModifyState) {
        let newRecord = TextRecord(modification.newText, isFavorite: modification.isFavorite)
        textCollection.append(newRecord)
        TextSettings.TextRecords.set(Array(textCollection))
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        modification.applyEdit()
        TextSettings.TextRecords.set(Array(textCollection))
    }
    
    func removeRecord(_ record: TextRecord) {
        guard let index = textCollection.firstIndex(of: record) else { return }
        textCollection.remove(at: index)
        TextSettings.TextRecords.set(textCollection)
    }
    
    func toggleFavorite(_ record: TextRecord) {
        record.isFavorite.toggle()
        TextSettings.TextRecords.set(textCollection)
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        textCollection.move(fromOffsets: source, toOffset: destination)
        TextSettings.TextRecords.set(textCollection)
    }
}

// MARK: Actual
@Observable
final class TextCollectionStateCoreDataBacked: TextCollectionState {
    // MARK: Instance Variables
    private(set) var textCollection: [TextRecord] = []
    
    private let container = {
        let container = NSPersistentContainer(name: "TextCollection")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("ERROR LOADING PERSISTENT STORES: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private let bkgContext: NSManagedObjectContext
    
    // MARK: Initializers
    init() {
        self.bkgContext = container.newBackgroundContext()
        self.bkgContext.undoManager = nil
        
        let request = NSFetchRequest<CDTextRecord>(entityName: CDTextRecord.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        let context = self.properContext
        
        context.performAndWait {
            do {
                self.textCollection = try context.fetch(request).map({ TextRecord($0) })
            } catch {
                print("failed to load text record from core data: \(error.localizedDescription)")
            }
        }
    }
    
    private var properContext: NSManagedObjectContext {
        if Thread.isMainThread {
            return container.viewContext
        } else {
            return bkgContext
        }
    }
    
    private func createNewRecord<T: CoreDataEntity>(_ object: T.Type, in context: NSManagedObjectContext) -> T? {
        var result: T?
        context.performAndWait {
            result = NSEntityDescription.insertNewObject(forEntityName: T.entityName, into: context) as? T
        }
        return result
    }
    
    
    // MARK: Public API
    func createRecord(_ modification: TextModifyState) {
        let context = properContext
        guard let newRecord = createNewRecord(CDTextRecord.self, in: context) else { return }
        
        context.performAndWait {
            newRecord.text = modification.newText
            newRecord.isFavorite = modification.isFavorite
            newRecord.id = UUID(uuidString: modification.id)
            newRecord.position = Int64(textCollection.count)
            
            do {
                try context.save()
                textCollection.append(TextRecord(newRecord))
            } catch {
                context.reset()
            }
        }
        
    }
    
    private func fetchRecord(with id: String, on context: NSManagedObjectContext) -> CDTextRecord? {
        let request = NSFetchRequest<CDTextRecord>(entityName: CDTextRecord.entityName)
        request.predicate = NSPredicate(format: "id == %@", id)
        request.fetchLimit = 1
        
        var result: CDTextRecord? = nil
        
        context.performAndWait {
            do {
                result = try context.fetch(request).first
            } catch {
                print("Failed to fetch Text Record with error: \(error.localizedDescription)")
            }
        }
        
        return result
    }
    
    func modifyRecord(_ modification: TextModifyState) {
        let context = properContext
        guard case .edit(let textRecord) = modification.intent else { return }
        guard let record = fetchRecord(with: textRecord.id, on: context) else { return }
        
        context.performAndWait {
            record.text = modification.newText
            record.isFavorite = modification.isFavorite
            do {
                try context.save()
                modification.applyEdit()
            } catch {
                print("Failed to save changes with error: \(error.localizedDescription)")
            }
        }
    }
    
    func removeRecord(_ record: TextRecord) {
        let context = properContext
        guard let cdRecord = fetchRecord(with: record.id, on: context) else { return }
        guard let index = textCollection.firstIndex(of: record) else { return }
        
        
        context.performAndWait {
            context.delete(cdRecord)
            do {
                try context.save()
                textCollection.remove(at: index)
            } catch {
                print("Failed to delete record")
            }
        }
    }
    
    func toggleFavorite(_ record: TextRecord) {
        let context = properContext
        guard let cdRecord = fetchRecord(with: record.id, on: context) else { return }
        
        context.performAndWait {
            cdRecord.isFavorite.toggle()
            
            do {
                try context.save()
                record.isFavorite.toggle()
            } catch {
                print("Failed to save favorite toggle: \(error.localizedDescription)")
            }
        }        
    }
    
    func moveRecords(from source: IndexSet, to destination: Int) {
        guard source.count > 0 else { return }
        
        let request = NSFetchRequest<CDTextRecord>(entityName: CDTextRecord.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "position", ascending: true)]
        
        let context = properContext
        
        context.performAndWait {
            do {
                var records = try context.fetch(request)
                
                var movedRecords: [CDTextRecord] = []
                for i in source.sorted(by: <) {
                    movedRecords.append(records[i])
                }
                
                for i in source.sorted(by: >) {
                    records.remove(at: i)
                }
                
                let actualDestination = destination > source.last! ? destination - source.count : destination
                records.insert(contentsOf: movedRecords, at: actualDestination)
                
                for (i, record) in records.enumerated() {
                    record.position = Int64(i)
                }
                
                try context.save()
                textCollection.move(fromOffsets: source, toOffset: destination)
            } catch {
                print("Failed to persist reordering")
            }
            
        }
    }
}
