//
//  Spot.swift
//  Snacktacular
//
//  Created by Ron Lemire on 10/18/25.
//

import Foundation
import FirebaseFirestore

struct Spot: Identifiable, Codable {
    @DocumentID var id: String?
    var name = ""
    var address = ""
}

extension Spot {
    static var preview: Spot {
        let newSpot = Spot(id: "1", name: "Boston Public Market", address: "Boston, MA")
        return newSpot
    }
}




/*
 var coordinate: CLLocationCoordinate2D
 var averageRating: Double
 var numberOfReviews: Int
 var postingUserID: String
 */
