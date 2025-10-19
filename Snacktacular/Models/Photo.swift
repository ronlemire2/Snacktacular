//
//  Photo.swift
//  Snacktacular
//
//  Created by Ron Lemire on 10/19/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = "" // This will hold the URL for loading the Image
    var description = ""
    var reviewer: String = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date() // current date/time
}
