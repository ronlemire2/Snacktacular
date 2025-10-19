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
    
    init(id: String? = nil, imageURLString: String = "", description: String = "", reviewer: String = "", postedOn: Date = Date()) {
        self.id = id
        self.imageURLString = imageURLString
        self.description = description
        self.reviewer = reviewer
        self.postedOn = postedOn
    }
}

extension Photo {
    static var preview: Photo {
        let newPhoto = Photo(id: "1", imageURLString: "https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Pizza-3007395.jpg/2880px-Pizza-3007395.jpg", description: "Yummy Pizza", reviewer: "little@caesars.com", postedOn: Date())
        return newPhoto
    }
}
