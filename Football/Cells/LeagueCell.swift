//
//  LeagueCell.swift
//  Football
//
//  Created by Nikita Galaganov on 08/08/2022.
//

import Foundation
import UIKit

class LeagueCell: UITableViewCell {
    @objc
    lazy var titleLabel: UILabel = {
        var result = UILabel(frame: self.bounds)
        self.contentView.addSubview(result)
        result.text = "Hello"
        return result
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.updateLayout()
        
//        self.titleLabel.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
//        self.contentView.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.vertical)
    }
    
    private func updateLayout() {
        let constraints = [
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func setUpWith(data: League) {
        self.titleLabel.text = data.name
    }
}
