//
//  CartViewController.swift
//  spaarksTask
//
//  Created by Tirumala on 03/12/23.
//

import UIKit

class CartViewController: UIViewController {
    

    @IBOutlet weak var productImg: UIImageView!
    
    var appointmentCancelled:(()->Void)?
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupUI(){
        
    }
    
    @IBAction func addbtnAction(_ sender: UIButton) {
        self.appointmentCancelled?()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    

}
