//
//  struct.swift
//  Demo
//
//  Created by apple on 2021/02/08.
//

import Foundation

struct DataInfo {
    var id: String
    var image: Data
    var species: String
    var feature: String
    var location: String
    
    init(id: String, image: Data, species: String, feature: String, location: String) {
        self.id = id
        self.image = image
        self.species = species
        self.feature = feature
        self.location = location
    }
}

struct FreeInfo {
    var id: String
    var title: String
    var content: String
    
    init(id: String, title: String, content: String) {
        self.id = id
        self.title = title
        self.content = content
    }
}

struct VTRInfo {
    var id: String
    var image: Data
    var location: String
    var houseName: String
    var date: String
    var peopleNum: String
    
    init(id: String, image: Data, location: String, houseName: String, date: String, peopleNum: String) {
        self.id = id
        self.image = image
        self.location = location
        self.houseName = houseName
        self.date = date
        self.peopleNum = peopleNum
    }
}

struct datasource {
    var id : String
    var image: Data
    var title : String
}

