//
//  CustomListRepository.swift
//  OBSS-Intern
//
//  Created by Mert Saygılı on 12.08.2024.
//

import RealmSwift

protocol CustomListRepositoryProtocol {
    func createCustomList(listName: String)
    func getCustomUserList() -> CustomUserList?
    func getAllCustomLists() -> List<CustomListEntity>?
    func getCustomList(id: ObjectId) -> CustomListEntity?
    func deleteCustomList(customList: CustomListEntity)
    func addMovieToList(listId: ObjectId, movie: MovieEntity)
    func removeMovieFromList(listId: ObjectId, movieId: Int)
}

class CustomListRepository: CustomListRepositoryProtocol {
    // MARK: --variables
    private let realm: Realm = StorageManager.shared.getRealmInstance
    
    // MARK: --protocol functions
    func createCustomList(listName: String) {
        do {
            try realm.write {
                let customUserList = realm.objects(CustomUserList.self).first ?? CustomUserList()
                let newList = CustomListEntity()
                newList.listName = listName
                customUserList.list.append(newList)
                realm.add(customUserList, update: .modified)
            }
        } catch {
            print("Error creating custom list: \(error)")
        }
    }
    
    func getCustomUserList() -> CustomUserList? {
        return realm.objects(CustomUserList.self).first
    }
    
    func getAllCustomLists() -> List<CustomListEntity>? {
        return getCustomUserList()?.list
    }
    
    func getCustomList(id: ObjectId) -> CustomListEntity? {
        return getCustomUserList()?.list.first(where: { $0._id == id })
    }
    
    func deleteCustomList(customList: CustomListEntity) {
        do {
            try realm.write {
                if let customUserList = getCustomUserList(),
                   let index = customUserList.list.index(of: customList) {
                    customUserList.list.remove(at: index)
                }
            }
        } catch {
            debugPrint("Error deleting custom list: \(error)")
        }
    }
    
    func addMovieToList(listId: ObjectId, movie: MovieEntity) {
        do {
            try realm.write {
                if let list = getCustomList(id: listId) {
                    list.movies.append(movie)
                }
            }
        } catch {
            debugPrint("Error adding movie to list: \(error)")
        }
    }
    
    func removeMovieFromList(listId: ObjectId, movieId: Int) {
        do {
            try realm.write {
                if let list = getCustomList(id: listId),
                   let index = list.movies.firstIndex(where: { $0.movieId == movieId }) {
                    list.movies.remove(at: index)
                }
            }
        } catch {
            debugPrint("Error removing movie from list: \(error)")
        }
    }
    
    // MARK: --public functions
    func initializeCustomList() {
        if Defaults.getBool(key: UserDefaultKeys.isCustomListInitialized) == true {
            return
        }
        
        do {
            try realm.write {
                if realm.objects(CustomUserList.self).isEmpty {
                    realm.add(CustomUserList())
                }
            }
        } catch {
            debugPrint("Error initializing custom list: \(error)")
        }
        
        Defaults.setValue(value: true, key: UserDefaultKeys.isCustomListInitialized)
    }
}
