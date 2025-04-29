//
//  GenreCell.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//

import UIKit
import SnapKit

class GenreCell: UICollectionViewCell {
    static let identifier = "GenreCell"
    private let titleLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        updateSelectionStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        let genresLayout = UICollectionViewFlowLayout()
        genresLayout.scrollDirection = .horizontal
        genresLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        contentView.backgroundColor = .systemGray6
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.lineBreakMode = .byTruncatingTail
        
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(6)
            make.left.right.equalToSuperview().inset(12)
        }
    }
    
    private func updateSelectionStyle() {
        if isSelected {
            contentView.backgroundColor = .systemBlue
            titleLabel.textColor = .white
            contentView.layer.borderColor = UIColor.systemBlue.cgColor
        } else {
            contentView.backgroundColor = .systemGray6
            titleLabel.textColor = .black
            contentView.layer.borderColor = UIColor.systemGray3.cgColor
        }
    }
    
    func configure(with genre: Genre) {
        titleLabel.text = genre.name
    }
}
