//
//  ProfileData.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 21.03.24.
//

import Foundation

public struct ProfileData: Equatable {
    let username: String
    let name: String
    let bio: String
    
    public static func == (lhs: ProfileData, rhs: ProfileData) -> Bool {
        return 
            (lhs.username == rhs.username &&
             lhs.bio == rhs.bio &&
             lhs.username == rhs.username)
    }
}
