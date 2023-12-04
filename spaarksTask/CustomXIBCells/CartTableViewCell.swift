//
//  CartTableViewCell.swift
//  spaarksTask
//
//  Created by Tirumala on 01/12/23.
//

import UIKit
import ValueStepper

class StarView: UIImageView {
    // You can customize your star view further if needed
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "star")
        self.contentMode = .scaleAspectFit
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



class CartTableViewCell: UITableViewCell {
    var onButtonPressed: (() -> ())?

    @IBOutlet weak var starView: StarRating!
    let valueStepper: ValueStepper = {
        let stepper = ValueStepper()
        stepper.tintColor = .black
        stepper.minimumValue = 0
        stepper.maximumValue = 1000
        stepper.stepValue = 0
        return stepper
    }()

    @IBOutlet weak var shopLbl: UILabel!
    @IBOutlet weak var shopImg: UIImageView!
    
    var rating: Int = 0 {
            didSet {
                updateStars()
            }
        }

    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var cartStepper: UIStepper!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var reviewRateLbl: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupStars() {
            for _ in 1...5 {
                let star = StarView(frame: CGRect(x: 0, y: 0, width: ratingStackView.frame.width, height: ratingStackView.frame.height))
                star.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(starTapped(_:)))
                star.addGestureRecognizer(tapGesture)
                ratingStackView.addArrangedSubview(star)
            }
            updateStars()
        }

        private func updateStars() {
            for (index, subview) in ratingStackView.arrangedSubviews.enumerated() {
                if let star = subview as? StarView {
                    star.image = index < rating ? UIImage(named: "star_filled") : UIImage(named: "star")
                }
            }
        }

        @objc private func starTapped(_ gesture: UITapGestureRecognizer) {
            guard let tappedView = gesture.view as? StarView else { return }
            if let index = ratingStackView.arrangedSubviews.firstIndex(of: tappedView) {
                rating = index + 1
            }
        }
    
    
    @IBAction func valueChanged1(sender: ValueStepper) {
        //onButtonPressed = {
        var vaule = 0
         vaule += 1
        self.valueStepper.valueLabel.text = "\(vaule)"
        //}
        // Use sender.value to do whatever you want
    }
    
}
