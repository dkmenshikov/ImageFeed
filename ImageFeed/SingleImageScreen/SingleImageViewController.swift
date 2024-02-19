//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 17.02.24.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image ?? UIImage())
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        imageView.frame.size = image?.size ?? .zero
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.5
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        rescaleAndCenterImageInScrollView(image: image ?? UIImage())
    }
    
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func didTapSharingButton(_ sender: Any) {
        guard let image else { return }
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender as? UIView
        self.present(activityVC, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
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
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let topInset = (visibleRectSize.height - newContentSize.height) / 2
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
    }
    
}

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterImageInScrollView(image: image ?? UIImage())
    }
    
}
