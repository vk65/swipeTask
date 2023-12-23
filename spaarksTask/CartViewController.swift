//
//  CartViewController.swift
//  spaarksTask
//
//  Created by Tirumala on 03/12/23.
//

import UIKit
import Foundation

struct Item {
    var name: String
    var description: String
    var price: String
    var tax:String
}

class CartViewController: UIViewController {
    
    @IBOutlet weak var priceLbl: UILabel!
    var agendaDataDict : ProductAdded!
    @IBOutlet weak var taxlbl: UILabel!
    @IBOutlet weak var product: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    var ctgyTitle =  ""
    var details =  ""
    var price =  ""
    var tax =  ""
    var image :  String?
    var selectedItems = [Item]()
   // var appointmentCancelled:(()->Void)?
    @IBOutlet weak var descriptionLbl: UILabel!
    var shopDataDictArr = [ShopDataModels]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .white
        setupUI()
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
        //for i in 0..<shopDataDictArr.count{
           // descriptionLbl.text = "\(ctgyTitle) \n \(details) /n \(price) \n \(tax)"
        //}
        descriptionLbl.numberOfLines = 0
        descriptionLbl.text = "Description: \(ctgyTitle)"
        product.text = "Product: \(details) "
        priceLbl.text = "Price: \(price)"
        taxlbl.text = "Tax: \(tax)"
        if let imageUrl = image {
               let urled = imageUrl
               let url = URL(string: urled)
            if url != nil{
                productImg.sd_setImage(with: url, completed: nil)
            }else{
                productImg.image = UIImage(named: "cart")
            }
            
           } else {
               productImg.image = UIImage(named: "cart")
           }
    }
    
    @IBAction func addbtnAction(_ sender: UIButton) {
      //  self.appointmentCancelled?()
        serviceForAgendas()
        self.dismiss(animated: true)
    }
    
    
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func createFormDataBody(parameters: [String: String]) -> Data {
        var components = URLComponents()
        components.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        guard let query = components.percentEncodedQuery?.data(using: .utf8) else {
            fatalError("Failed to encode parameters")
        }
        
        return query
    }

    func performPostRequest(url: URL, parameters: [String: String], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = createFormDataBody(parameters: parameters)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
            print(data)
        }
        
        task.resume()
    }
    
    func serviceForAgendas(){
        let apiUrl = "https://app.getswipe.in/api/public/add"
        
        let parameterswe:[String:String] = ["product_name":"\(ctgyTitle)", "product_type":"\(String(describing: details))","price":"\(price)", "tax":"\(tax)"]
        print(parameterswe)
        let body = createFormDataBody(parameters: parameterswe)
      //  postContent(path:URL(string:apiUrl )! , modelType: ProductAdded.self, params: parameterswe, method: "POST") { (payload, _) in
        //performPostRequest(url: URL(string:apiUrl)!, parameters: parameterswe) { (payload, response, error) in
            // Handle the response or error here
        sendPostRequestWithFormData(url: apiUrl, params: parameterswe)
           // print(payload)
            
           // self.agendaDataDict = payload
           
           
//            self.agendLbl.text = self.agendaDataDict?.cmd ?? ""
//            self.agendaImg.clipsToBounds = true
//            self.agendaImg.layer.cornerRadius = self.agendaImg.frame.height/2
//            if let imageUrl = self.agendaDataDict?.data?.first?.attendees.first?.image, let url = URL(string: imageUrl) {
//                self.agendaImg.sd_setImage(with: url, completed: nil)
//            } else {
//                self.agendaImg.image = nil
//            }
//            self.listTableview.reloadData()
        }
    
    
    func showAlert(message: String) {
           let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)

           let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
               // Handle the OK button action if needed
           })

           alertController.addAction(okAction)

           present(alertController, animated: true, completion: nil)
       }
    

    func sendPostRequestWithFormData(url:String, params:[String:Any]) {
        // Define the URL for your API endpoint
        let apiUrl = URL(string: url)!

        // Create the request
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "POST"

        // Define the dictionary to be sent in the form data
        let formData = params
        //["key1": "value1", "key2": "value2"]

        // Convert the dictionary to Data
        let formDataString = formData.map { key, value in
            return "\(key)=\(value)"
        }.joined(separator: "&")

        let formDataData = formDataString.data(using: .utf8)

        // Set the HTTP body with form data
        request.httpBody = formDataData

        // Set the Content-Type header for form data
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        // Create the URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle the response
            if let error = error {
                print("Error: \(error)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                // Decode the response using JSONDecoder
                let decoder = JSONDecoder()
                let responseModel = try decoder.decode(ProductAdded.self, from: data)
                
                // Use the responseModel as needed
                print("Response: \(responseModel)")
                DispatchQueue.main.async {
                    self.showAlert(message: "\(responseModel.message)")
                }
            } catch {
                print("Error decoding response: \(error)")
            }
        }

        // Start the URLSession task
        task.resume()
    }
}
