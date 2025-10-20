//
//  ReviewViewModel.swift
//  Snacktacular
//
//  Created by Ron Lemire on 10/20/25.
//

import Foundation
import FirebaseFirestore

@Observable
class ReviewViewModel {
    var review = Review()
    
    static func saveReview(spot: Spot, review: Review) async -> Bool { // nil is effort failed, otherwise return spot.id
        let db = Firestore.firestore()
        
        //TODO: replace spot.id with guard let spotID
        /*
         guard let spotID = spot.id else {
            print("ERROR: spot.id = nil")
         */
        let collectionString = "spots/\(spot.id ?? "def")/reviews"
        
        if let id = review.id { 
            do {
                try await db.collection(collectionString).document(id).setData(review.dictionary)
                print("Data updated sucessfully")
                return true
            } catch {
                print("ERROR: Could not update data in 'reviews' \(error.localizedDescription)")
                return false
            }
        } else {
            do {
                _ = try await db.collection(collectionString).addDocument(data: review.dictionary)
                print("Data added successfully")
                return true
            } catch {
                print("ERROR: Could not create a new review in 'reviews' \(error.localizedDescription)")
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
