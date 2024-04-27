//
//  WebViewViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Dmitriy Menshikov on 26.04.24.
//

import ImageFeed
import Foundation

final class WebViewViewControllerSpy: WebViewControllerProtocol {
    
    var isLoadCalled: Bool = false
    
    var presenter: (any ImageFeed.WebViewPresenterProtocol)?
    
    func load(request: URLRequest) {
        isLoadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
