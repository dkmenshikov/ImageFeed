//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Dmitriy Menshikov on 16.02.24.
//

import Kingfisher
import UIKit

final class ProfileViewController: UIViewController {
    
    //    MARK: - Private properties (screen views)
    
    private var nameLabel = UILabel()
    private var nicknameLabel = UILabel()
    private var bioLabel = UILabel()
    private var labelsStack = UIStackView()
    
    private var userpicImageView = UIImageView()
    private var exitButton = ProfileExitButton()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    //    MARK: - Lyfecycle
    
    override func viewDidLoad() {
        setViews()
        updateProfileData()
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()
            }
        
        updateAvatar()
        
    }
    
//    MARK: - Private methods
    
    private func updateAvatar() {
        let profileImageService = ProfileImageService.shared
        guard
            let profileImageURL = profileImageService.profileImageURL,
            let url = URL(string: profileImageURL)
        else { return }
        userpicImageView.contentMode = .scaleAspectFill
        userpicImageView.kf.indicatorType = .activity
        let processor = RoundCornerImageProcessor(cornerRadius: 25)
        userpicImageView.kf.setImage(with: url,
                                     placeholder: UIImage.userPicStub,
                                     options: [.processor(processor)]) { result in
            switch result {
            case .success(_): break
            case .failure(let error):
                print("[LOG]: \(error)")
            }
        }
    }
    
    private func updateProfileData() {
        let profileService = ProfileService.shared
        let profileData = profileService.profile
        nameLabel.text = profileData.name
        if profileData.username != "" {
            nicknameLabel.text = "@"+profileData.username
        }
        bioLabel.text = profileData.bio
    }
    
}

// MARK: - UI setter

extension ProfileViewController {
    
//    MARK: - Views creation private methods
    
    private func setViews() {
        view.backgroundColor = .ypBlack
        
        userpicImageView = createUserpic(image: .userPicStub)
        exitButton = createExitButton()
        nameLabel = createLabel(text: "Name Lastname", textSize: 23, textColor: .ypWhite)
        nicknameLabel = createLabel(text: "@nickname", textSize: 13, textColor: .ypGray)
        bioLabel = createLabel(text: "statement", textSize: 13, textColor: .ypWhite)
        labelsStack = createStackView (nameLabel: nameLabel, nicknameLabel: nicknameLabel, statementLabel: bioLabel)
        
        [userpicImageView, exitButton, labelsStack].forEach {
            view.addSubview($0)
        }
        
        setViewsConstraints()
    }
    
    private func createUserpic(image: UIImage) -> UIImageView {
        let userpicImageView = UIImageView()
        userpicImageView.image = .userPicStub
        return userpicImageView
    }
    
    private func createExitButton () -> ProfileExitButton {
        return ProfileExitButton()
    }
    
    private func createLabel(text: String, textSize: CGFloat, textColor: UIColor) -> UILabel {
        let label: UILabel = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = UIFont.systemFont(ofSize: textSize)
        return label
    }
    
    private func createStackView(nameLabel: UILabel, nicknameLabel: UILabel, statementLabel: UILabel) -> UIStackView {
        let stack = UIStackView(arrangedSubviews: [nameLabel, nicknameLabel, statementLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 8
        return stack
    }
    
//    MARK: - Constraints setter
    
    private func setViewsConstraints() {
        
        // tAMIC off for all views
        [userpicImageView, exitButton, nameLabel, nicknameLabel, bioLabel, labelsStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // userpic constraints
        NSLayoutConstraint.activate([
            userpicImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            userpicImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // exitButton constraints
        NSLayoutConstraint.activate([
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            exitButton.centerYAnchor.constraint(equalTo: userpicImageView.centerYAnchor)
        ])
        
        // labels constraints
        [nameLabel, nicknameLabel, bioLabel].forEach {
            $0.heightAnchor.constraint(equalToConstant: 18).isActive = true
        }
        
        // labelsStack constraints
        NSLayoutConstraint.activate([
            labelsStack.topAnchor.constraint(equalTo: userpicImageView.bottomAnchor, constant: 8),
            labelsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])

    }
}
