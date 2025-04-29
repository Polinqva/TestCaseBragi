//
//  MovieCell.swift
//  TestCaseBragi
//
//  Created by Polina Smirnova on 28.04.2025.
//

import UIKit
import SnapKit
import Kingfisher

class MovieItemCell: UICollectionViewCell {
    
    static let identifier = "MovieItemCell"
    
    private let posterImageView = UIImageView()
    private let infoLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.lightGray.cgColor

        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true
        
        infoLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(infoLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(8)
        }
    }
    
    func configure(with item: MediaItem, detail: MediaDetail?) {
        if let path = item.posterPath {
            let url = URL(string: Constants.imageBaseURL + path)
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
        
        let title = item.title ?? item.name ?? "Unknown"
        let rating = String(format: "%.1f", item.voteAverage)
        let budget = detail?.budget != nil ? "\(detail!.budget! / 1_000_000) M" : "-"
        let revenue = detail?.revenue != nil ? "\(detail!.revenue! / 1_000_000) M" : "-"
        
        infoLabel.text = """
        Title: \(title)
        Rating: \(rating)
        Budget: \(budget)
        Revenue: \(revenue)
        """
    }
}
