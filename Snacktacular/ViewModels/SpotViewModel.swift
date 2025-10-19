//
//  SpotViewModel.swift
//  Snacktacular
//
//  Created by Ron Lemire on 10/18/25.
//

import Foundation
import FirebaseFirestore

@Observable
class SpotViewModel {
    var spot = Spot()
    
    static func saveSpot(spot: Spot) -> Bool {
        let db = Firestore.firestore()
        
        if let id = spot.id { // spot must already exist, so save
            do {
                try db.collection("spots").document(id).setData(from: spot)
                print("Data updated sucessfully")
                return true
            } catch {
                print("ERROR: Could not update data in 'spots' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                try db.collection("spots").addDocument(from: spot)
                print("Data added successfully")
                return true
            } catch {
                print("ERROR: Could not create a new spot in 'spots' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    static func deleteSpot(spot: Spot) {
        let db = Firestore.firestore()
        guard let id = spot.id else {
            print("No spot.id")
            return
        }
        
        Task {
            do {
                try await db.collection("spots").document(id).delete()
            } catch {
                print("ERROR: Could not delete document \(id). \(error.localizedDescription)")
            }
        }
    }
}
