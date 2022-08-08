//
//  OverlayView.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation
import UIKit

enum OverlayState {
    case hideView
    case loading
    case error
}

class OverlayView: UIView {
    
    var reload: (() -> Void)?
    
    //MARK: - UI
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    private let reloadButton: UIButton = UIButton()
    private let label: UILabel = UILabel()
    
    var errorMessage: String
    
    init(errorMessage: String, state: OverlayState) {
        self.errorMessage = errorMessage
        super.init(frame: CGRect.infinite)
        
        setUp()
        setState(state: state)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addViews()
        addConstraints()
    }
    
    private func addViews() {
        addSubview(loadingIndicator)
        addSubview(reloadButton)
        addSubview(label)
        
        label.text = errorMessage
    }
    
    private func addConstraints() {
        let constraints = [
            loadingIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            label.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            
            reloadButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            reloadButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            reloadButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            reloadButton.widthAnchor.constraint(equalToConstant: 65)
        ]
        NSLayoutConstraint.activate(constraints)
        
        reloadButton.layer.cornerRadius = 14
        reloadButton.backgroundColor = .systemRed
        reloadButton.setTitle("Try Again", for: .normal)
        reloadButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        loadingIndicator.startAnimating()
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        reload?()
    }
    
    func setState(state: OverlayState) {
        switch state {
        case .hideView:
            hide()
        case .loading:
            showLoading()
        case .error:
            showError()
        }
    }
    
    private func hide() {
        DispatchQueue.main.async {
            self.isHidden = true
        }
    }
    
    private func showError() {
        DispatchQueue.main.async {
            self.isHidden = false
            
            self.loadingIndicator.isHidden = true
            
            self.label.isHidden = false
            self.reloadButton.isHidden = false
        }
    }
    
    private func showLoading() {
        DispatchQueue.main.async {
            self.isHidden = false
            
            self.loadingIndicator.isHidden = false
            
            self.label.isHidden = true
            self.reloadButton.isHidden = true
        }
    }
}
