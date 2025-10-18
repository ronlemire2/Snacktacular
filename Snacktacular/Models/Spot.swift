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

/*
 var coordinate: CLLocationCoordinate2D
 var averageRating: Double
 var numberOfReviews: Int
 var postingUserID: String
 */
