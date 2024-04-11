//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 17.02.24.
//

import Kingfisher
import ProgressHUD
import UIKit

final class SingleImageViewController: UIViewController {
    
//    MARK: - Publick properties
    
    var imageURL: URL? 
    
//    MARK: - Private properties
    
    private var image = UIImage()
    
//    MARK: - IBOutlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
//    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setImage()
    }
    
//    MARK: - IBActions
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapSharingButton(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true)
    }
    
//    MARK: - Private methods
    
    private func rescaleAndCenterImageInScrollView(image: UIImage, isFirstSet: Bool) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        if scrollView.zoomScale < scale {
            scrollView.setZoomScale(scale, animated: true)
        }
        if isFirstSet {
            scrollView.setZoomScale(scale, animated: true)
        }
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let topInset = (visibleRectSize.height - newContentSize.height) / 2
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: imageURL) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let kfResult):
                self.image = kfResult.image
                self.imageView.image = self.image
                self.imageView.frame.size = self.image.size
                self.scrollView.delegate = self
                self.scrollView.minimumZoomScale = 0.1
                self.scrollView.maximumZoomScale = 3.5
                self.scrollView.showsVerticalScrollIndicator = false
                self.scrollView.showsHorizontalScrollIndicator = false
                self.rescaleAndCenterImageInScrollView(image: self.image, isFirstSet: true)
            case .failure(let error):
                print(error)
                showError()
            }
        }
    }
    
    private func showError() {
        let alertPresenter = AlertPresenter(delegate: self)
        let alertData = AlertModel(
            title: "Что-то пошло не так",
            text: "Попробовать еще раз?",
            firstAction: .init(actionText: "Повторить",
                               actionCompletion: { [weak self] _ in
                        guard let self else { return }
                        alertPresenter.dismissAlert()
                        setImage()
                    }),
            secondAction: .init(actionText: "Не надо",
                                actionCompletion: { [weak self] _ in
                        guard self != nil else { return }
                        alertPresenter.dismissAlert()
                    }),
            accessibilityIdentifier: "Alert"
        )
        alertPresenter.showAlert(alertData: alertData)
    }
}

//     MARK: - UIScrollViewDelegate extension

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterImageInScrollView(image: image, isFirstSet: false)
    }
    
}
