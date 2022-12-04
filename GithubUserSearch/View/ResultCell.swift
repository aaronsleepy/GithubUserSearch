//
//  ResultCell.swift
//  GithubUserSearch
//
//  Created by Aaron on 2022/12/04.
//

import UIKit

class ResultCell: UICollectionViewCell {
    
    @IBOutlet weak var user: UILabel!
    
    func configure(_ text: String) {
        user.text = text
    }
    
}
