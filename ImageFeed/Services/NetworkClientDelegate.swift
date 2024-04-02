//
//  NetworkClientDelegate.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 19.03.24.
//

import UIKit

protocol NetworkClientDelegate: AnyObject {
    var isFetchingNow: Bool { get set }
}
