//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Dmitriy Menshikov on 26.04.24.
//

@testable import ImageFeed
import XCTest

final class WebViewTest: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        
        //        GIVEN
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewController") as? WebViewViewController else { return }
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //        WHEN
        _ = viewController.view
        
        //        THEN
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        
        //        GIVEN
        let viewController = WebViewViewControllerSpy()
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        viewController.presenter = presenter
        presenter.view = viewController
        
        //        WHEN
        presenter.viewDidLoad()
        
        //        THEN
        XCTAssertTrue(viewController.isLoadCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        
        //        GIVEN
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress = Float(0.6)
        
        //        WHEN
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //        THEN
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressVisibleWhenOne() {
        
        //        GIVEN
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress = Float(1)
        
        //        WHEN
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //        THEN
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        
        //        GIVEN
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //        WHEN
        guard let url = authHelper.authURL() else { return }
        let urlString = url.absoluteString
        
        //        THEN
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        
        //        GIVEN
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native") else { return }
        let testcode = "testcode"
        urlComponents.queryItems = [URLQueryItem(name: "code", value: testcode)]
        guard let url = urlComponents.url else { return }
        let authHelper = AuthHelper()
        
        //        WHEN
        let code = authHelper.code(from: url)
        
        //        THEN
        XCTAssertEqual(code, testcode)
    }
    
    //    MARK: - Profile screen tests
    
    func testProfilePresenterUpdatesDataAfterControllersViewDidLoad() {
        
        //        GIVEN
        let vc = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        vc.configure(presenter: presenter)
        
        //        WHEN
        _ = vc.view
        
        //        THEN
        XCTAssertTrue(presenter.isUpdateAvatarCalled)
        XCTAssertTrue(presenter.isUpdateProfileCalled)
    }
    
    func testProfilePresenterClearsUserDataAfterLogout() {
        
        //        GIVEN
        let presenter = ProfilePresenter()
        let tokenStorageService = OAuthTokenStorageService()
        let profileService = ProfileService.shared
        let imageService = ProfileImageService.shared
        
        var token = tokenStorageService.authToken
        let profileInfo = profileService.profile
        let emptyProfileInfo = ProfileData(username: "", name: "", bio: "")
        let imageURL = imageService.profileImageURL
        
        //        WHEN
        presenter.logout()
        
        //        THEN
        XCTAssertNil(token)
        XCTAssertEqual(profileInfo, emptyProfileInfo)
        XCTAssertNil(imageURL)
    }
    
    func testProfileViewControllerConfigureLinksWithPresenter() {
        
        //        GIVEN
        let vc = ProfileViewController()
        let presenter = ProfilePresenter()
        
        //        WHEN
        vc.configure(presenter: presenter)
        
        //        THEN
        XCTAssertTrue(vc === presenter.view)
        XCTAssertTrue(vc.presenter === presenter)
    }
    
    //    MARK: - ImagesList screen tests
    
    func testImagesListViewControllerConfigureLinksWithPresenter() {
        
        //        GIVEN
        let vc = ImagesListViewController()
        let presenter = ImagesListPresenter()
        
        //        WHEN
        vc.configure(presenter: presenter)
        
        //        THEN
        XCTAssertTrue(vc === presenter.view)
        XCTAssertTrue(vc.presenter === presenter)
    }
    
    func testCleanPhotos() {
        
        //        GIVEN
        let vc = ImagesListViewController()
        let presenter = ImagesListPresenter()
        vc.configure(presenter: presenter)
        
        //        WHEN
        presenter.cleanImagesList()
        
        //        THEN
        XCTAssert(presenter.photos == [])
    }
    
}