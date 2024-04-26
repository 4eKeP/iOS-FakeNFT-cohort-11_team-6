//
//  CatalogViewCell.swift
//  FakeNFT
//
//  Created by admin on 24.03.2024.
//

import UIKit


final class CatalogViewCell: UITableViewCell, ReuseIdentifying {
    
    lazy var cellImage = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = Asset.Colors.Universal.ypUniBG.color
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var cellNameLabel = {
        var label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = Asset.Colors.ypBlack.color
        return label
    }()
    
    static let catalogViewCellReuseIdentifier = "CatalogViewCellReuseIdentifier"
    private let cellImageHeight: CGFloat = 140
    private let cellLabelSpacing: CGFloat = 4
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: CatalogViewCell.catalogViewCellReuseIdentifier)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeCell(nftCatalogModel nftModel: NFTCatalogModel, coverURL url: URL?) -> CatalogViewCell {
        self.cellImage.kf.setImage(with: url)
        self.cellNameLabel.text = " \(nftModel.name) (\(nftModel.nftCount))"
        return self
    }
}

private extension CatalogViewCell {
    func configCell() {
        contentView.addSubview(cellImage)
        contentView.addSubview(cellNameLabel)
        contentView.backgroundColor = Asset.Colors.ypWhite.color
        
        NSLayoutConstraint.activate([
            cellImage.heightAnchor.constraint(equalToConstant: cellImageHeight),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cellNameLabel.topAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: cellLabelSpacing),
            cellNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])
    }
}
