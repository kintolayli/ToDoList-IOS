//
//  CustomCell.swift
//  ToDoList
//
//  Created by Илья Лотник on 09.02.2024.
//


import UIKit

class CustomCell: UITableViewCell {
    
    static func formatDate(isoDate: String) -> String {
    //    функция принимает строку в формате ISO 2023-11-28T23:13:08.608230Z
    //    и возвращает строку в виде 11 ноября 2023 г. в 23:13
        
        let formatter = DateFormatter()

        formatter.dateFormat = Constants.dateFormat
        formatter.locale = Locale(identifier: Constants.locale)
        
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: Constants.secondsFromGMT)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate,
            .withFractionalSeconds]

        guard let realDate = isoDateFormatter.date(from: isoDate) else { return "" }
        
        return formatter.string(from: realDate)
    }
    
    static let dynamicColorFirst = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor.white // Белый цвет в темном режиме
        case .light, .unspecified:
            return UIColor.black // Черный цвет в светлом режиме
        @unknown default:
            return UIColor.black // Черный цвет по умолчанию
        }
    }
    
    static let dynamicColorSecond = UIColor { traitCollection in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return UIColor(hue: 0, saturation: 0, brightness: 1, alpha: 0.5) // Белый цвет в темном режиме
        case .light, .unspecified:
            return UIColor.systemGray // Черный цвет в светлом режиме
        @unknown default:
            return UIColor.systemGray // Черный цвет по умолчанию
        }
    }
    
    static let identifier = "CustomCell"
    static let cellSize = 25
    static let cellCornerRadius = CustomCell.cellSize / 2
    
    private let myImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "circle")
        iv.layer.cornerRadius = CGFloat(cellCornerRadius)
        iv.clipsToBounds = true
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = dynamicColorFirst
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Error"
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = dynamicColorSecond
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 10, weight: .light)
        label.text = "Error"
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with item: TodoItem) {
        
        if self.isEditing {
            self.titleLabel.alpha = 0.5
            self.timeLabel.alpha = 0.5
            self.myImageView.alpha = 0.5
        } else {
            self.titleLabel.alpha = 1.0
            self.timeLabel.alpha = 1.0
            self.myImageView.alpha = 1.0
        }
        
        self.myImageView.image = item.isCompleted ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        self.titleLabel.text = "\(item.name)"
        self.timeLabel.text = CustomCell.formatDate(isoDate: item.created)
    }
    
    private func setupUI() {
        
        self.contentView.addSubview(myImageView)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(timeLabel)
        
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            myImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            myImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
            myImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            myImageView.heightAnchor.constraint(equalToConstant: CGFloat(CustomCell.cellSize)),
            myImageView.widthAnchor.constraint(equalToConstant: CGFloat(CustomCell.cellSize)),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,  constant: 8),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: self.myImageView.trailingAnchor,  constant: 16),
            timeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,  constant: 8),
            timeLabel.bottomAnchor.constraint(equalTo: self.myImageView.bottomAnchor, constant: 4),
        ])
    }
}
