//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 25.04.24.
//

import Foundation

protocol WebViewPresenterProtocol: AnyObject {
    var view: WebViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
//    MARK: - ViewController
    
    weak var view: WebViewControllerProtocol?
    
//    MARK: - Other public properties
    
    let authHelper: AuthHelperprotocol
    
//    MARK: - Init
    
    init(authHelper: AuthHelperprotocol) {
        self.authHelper = authHelper
    }
    
//    MARK: - Public methods
    
    func viewDidLoad() {
        didUpdateProgressValue(0)
        guard let request = authHelper.authRequest() else { return }
        view?.load(request: request)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgree = shouldHideProgress(for: Float(newValue))
        view?.setProgressHidden(shouldHideProgree)
    }
    
    func code(from url: URL) -> String? {
        return authHelper.code(from: url)
    }
    
//    MARK: - Private methods
    
    private func shouldHideProgress(for value: Float) -> Bool {
        return abs(value - 1) <= 0.0001
    }
    
}
