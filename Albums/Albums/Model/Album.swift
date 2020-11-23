//
//  Album.swift
//  Albums
//
//  Created by Alfredo Colon on 11/22/20.
//

import UIKit

struct Album: Codable {
    var id: UUID
    var name: String
    var artist: String
    var coverArt: [String]
    var genres: [String]
    var songs: [Song]
    
    enum AlbumCodingKeys: String, CodingKey {
        case id
        case name
        case artist
        case coverArt
        case genres
        case songs
        
        enum CoverArtCodingKeys: String, CodingKey {
            case url
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: AlbumCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(artist, forKey: .artist)
        try container.encode(genres, forKey: .genres)
        try container.encode(songs, forKey: .songs)
        
        var coverArtContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        for art in coverArt {
            var coverArtStringContainer = coverArtContainer.nestedContainer(keyedBy: AlbumCodingKeys.CoverArtCodingKeys.self)
            try coverArtStringContainer.encode(art, forKey: .url)
        }
    }
}

extension Album {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AlbumCodingKeys.self)
        artist = try container.decode(String.self, forKey: .artist)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(UUID.self, forKey: .id)
        genres = try container.decode([String].self, forKey: .genres)
        songs = try container.decode([Song].self, forKey: .songs)
        
        var covers = [String]()
        var coversContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        while !coversContainer.isAtEnd {
            let coverArtContainer = try coversContainer.nestedContainer(keyedBy: AlbumCodingKeys.CoverArtCodingKeys.self)
            let coverArt = try coverArtContainer.decode(String.self, forKey: .url)
            covers.append(coverArt)
        }
        self.coverArt = covers
    }
}

struct Song: Codable {
    let duration: String
    let id: UUID
    let name: String
    
    enum SongCodingKeys: String, CodingKey {
        case duration
        case id
        case name
    }
    
    enum DurationDescriptionCodingKey: String, CodingKey {
        case duration
    }
    
    enum NameDescriptionCodingKey: String, CodingKey {
        case title
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SongCodingKeys.self)
        
        try container.encode(id, forKey: .id)
        
        var nameContainer = container.nestedContainer(keyedBy: NameDescriptionCodingKey.self, forKey: .name)
        try nameContainer.encode(name, forKey: .title)
        
        var durationContainer = container.nestedContainer(keyedBy: DurationDescriptionCodingKey.self, forKey: .duration)
        try durationContainer.encode(duration, forKey: .duration)
    }
}

extension Song {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SongCodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        
        let nameContainer = try container.nestedContainer(keyedBy: NameDescriptionCodingKey.self, forKey: .name)
        name = try nameContainer.decode(String.self, forKey: .title)
        
        let durationContainer = try container.nestedContainer(keyedBy: DurationDescriptionCodingKey.self, forKey: .duration)
        duration = try durationContainer.decode(String.self, forKey: .duration)
    }
}
