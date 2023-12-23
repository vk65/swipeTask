//
//  ViewController.swift
//  spaarksTask
//
//  Created by Tirumala on 01/12/23.
//

import UIKit
import SDWebImage
import ValueStepper

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var shopDataDict = [ShopDataModels]()
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var shopTableview: UITableView!
    var filteredData: [ShopDataModels] = []
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        searchBar.delegate = self
        shopTableview.register(UINib(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: "CartTableViewCell")
        serviceForAgendas()
       
        // Do any additional setup after loading the view.
    }

    func serviceForAgendas(){
        let apiUrl = "https://app.getswipe.in/api/public/get"
        
        getServicesData(generalType: [ShopDataModels].self, apiEndPoint: URL(string: apiUrl)!, method: "GET") { (payload, _) in
            
            print(payload)
            self.shopDataDict = payload
//            for i in 0..<shopDataDict.count{
//                if let imageUrl = payload.imgPath {
//                    let urled = imageUrl + payload.data.headerImg
//                    let url = URL(string: urled)
//                    self.headerImg.sd_setImage(with: url, completed: nil)
//                } else {
//                    self.headerImg.image = nil
//                }
//            }
            self.filteredData = self.shopDataDict
            self.shopTableview.delegate = self
            self.shopTableview.dataSource = self
            self.activityIndicator.stopAnimating()
            self.shopTableview.reloadData()
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                   // Stop the activity indicator when the data loading is complete
                   self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true

                   // Reload the table view data
            self.shopTableview.reloadData()
               }
        
        
    }
    

    
       
        
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredData.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let sectionCell = shopTableview.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as? CartTableViewCell
                    else {
                        fatalError("dequeuing issue")
                }
            let filteed = filteredData
            if let imageUrl = filteed[indexPath.row].image {
                   let urled = imageUrl
                   let url = URL(string: urled)
                if url != nil{
                    sectionCell.shopImg.sd_setImage(with: url, completed: nil)
                }else{
                    sectionCell.shopImg.image = UIImage(named: "cart")
                }
                
               } else {
                   sectionCell.shopImg.image = UIImage(named: "cart")
               }
            
            sectionCell.selectionStyle = .none
            sectionCell.shopLbl.text = "\(filteed[indexPath.row].productName ?? "")"
            sectionCell.reviewRateLbl.text = "Tax: \(filteed[indexPath.row].tax ?? 0)"
            sectionCell.descriptionLbl.text = "\(filteed[indexPath.row].productType ?? "")"

            sectionCell.priceLbl.text = "Rs \(filteed[indexPath.row].price ?? 0.0)"
          //  let frame = CGRect(x: 0, y: 0, width: sectionCell.starView.frame.width - 40, height: sectionCell.starView.frame.height)
           // let starView = StarRating(frame: frame, totalStars: 5, selectedStars: 1)
           // starView.addTarget(self, action: #selector(starRatingValueChanged(_:)), for: .valueChanged)
            //starView.center = view.center
           // sectionCell.starView.addSubview(starView)
           
            return sectionCell
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        var items = Item(name: shopDataDict[indexPath.row].productName, description: shopDataDict[indexPath.row].productType, price: "\(shopDataDict[indexPath.row].price)", tax: "\(shopDataDict[indexPath.row].tax)")
        home.selectedItems.append(items)
        home.ctgyTitle = shopDataDict[indexPath.row].productName
        home.price = "\(shopDataDict[indexPath.row].price)"
        home.details = shopDataDict[indexPath.row].productType
        home.tax = "\(shopDataDict[indexPath.row].tax)"
       // let filteed = filteredData
      //  home.descriptionLbl.text = filteed[indexPath.row].productType
//        if let imageUrl = filteed[indexPath.row].image {
//               let urled = imageUrl
//               let url = URL(string: urled)
//            if url != nil{
//                home.productImg.sd_setImage(with: url, completed: nil)
//            }else{
//                home.productImg.image = UIImage(named: "cart")
//            }
//        } else {
//            home.productImg.image = UIImage(named: "cart")
//        }
        home.modalPresentationStyle = .overFullScreen
        home.view.backgroundColor = .white
        navigationController?.pushViewController(home, animated: true)
//        home.appointmentCancelled = {
//            let cell = self.shopTableview.cellForRow(at: indexPath) as! CartTableViewCell
//           // cell.valueChanged1(sender: ValueStepper())
//            //cell.valueStepper.increaseValue()
//          //  self.arrAppointmentsList.remove(at: indexPath.row)//[indexPath.row]
//            self.shopTableview.reloadData()
//        }
       // home.passID = "\(agendaDataDict?.data?[indexPath.row].id ?? 0)"
      //  present(home, animated: true)
    }
        
}


extension UIViewController{
    
   
    
    
    func request(path: URL, method: String, bodyData: [String: Any] = [:], completionHandler: @escaping (_: Data, _: HTTPURLResponse) -> Void) {
        guard let url = URL(string: path.absoluteString) else { return }
        
        // TODO: Set IsInCanada flag
        // request.setValue(1, forHTTPHeaderField: "x-canada-filter")
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if !bodyData.isEmpty {
            let jsonData = try? JSONSerialization.data(withJSONObject: bodyData)
            request.httpBody = jsonData
        }
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Client Error: \(error.localizedDescription)")
                // CustomLoader.shared.hide()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                // CustomLoader.shared.hide()
                print("Response Error: \(response!)")
                return
            }
            guard let data = data else { return }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            if path.absoluteString.contains("/api/job/create-payment-intent") {
                // paymentIntent = data
            }
            completionHandler(data, httpResponse)
            
        }.resume()
        
    }
    
    func requestGET(path: URL, method: String,  completionHandler: @escaping (_: Data, _: HTTPURLResponse) -> Void) {
        guard let url = URL(string: path.absoluteString) else { return }
        
      
        
        // TODO: Set IsInCanada flag
        // request.setValue(1, forHTTPHeaderField: "x-canada-filter")
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
        print(request)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Client Error: \(error.localizedDescription)")
                // CustomLoader.shared.hide()
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                // CustomLoader.shared.hide()
                print("Response Error: \(response!)")
                return
            }
            guard let data = data else { return }
            let str = String(decoding: data, as: UTF8.self)
            print(str)
            if path.absoluteString.contains("/api/job/create-payment-intent") {
                // paymentIntent = data
            }
            completionHandler(data, httpResponse)
            
        }.resume()
        
    }
    
    func postContent<T>(path: URL, modelType: T.Type, params: [String: Any] = [:],method:String, completion: @escaping (_ : T, _ : HTTPURLResponse) -> Void) where T : Decodable {
        request(path: path, method: method, bodyData: params) { (data, httpResponse) in
            do {
                //                     self.data = data
                let decodedResponse = try JSONDecoder().decode(modelType, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse, httpResponse)
                }
            }
            catch {
                print("Error for URL: \(httpResponse.url?.absoluteString ?? "") in decoding the response: ", error)
                print(httpResponse)
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let statusMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    
                    print("Status Code: \(statusCode)")
                    print("Status Message: \(statusMessage)")
                    
                }
                
            }
        }
    }
    
   
    
     func getServicesData<T>(generalType: T.Type,apiEndPoint:URL, method:String,  completionHandler:  @escaping (_ : T, _ : HTTPURLResponse) -> Void) where T : Decodable {
        requestGET(path: apiEndPoint, method: method) { (data, httpResponse) in
            do {
                //                     self.data = data
                let decodedResponse = try JSONDecoder().decode(generalType, from: data)
                DispatchQueue.main.async {
                    completionHandler(decodedResponse, httpResponse)
                }
            }
            catch {
                print("Error for URL: \(httpResponse.url?.absoluteString ?? "") in decoding the response: ", error)
                print(httpResponse)
                if let httpResponse = httpResponse as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    let statusMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    
                    print("Status Code: \(statusCode)")
                    print("Status Message: \(statusMessage)")
                    
                }
                
            }
        }
    }
    
        
    
    
    
}


extension UISegmentedControl {
    func makeMultiline(withFontName fontName: String, fontSize: CGFloat, textColor: UIColor){
        for index in 0...self.numberOfSegments - 1 {
            
            let label = UILabel(frame: CGRectMake(0,0,self.frame.width/CGFloat(self.numberOfSegments),self.frame.height))
            label.font = UIFont(name: fontName, size: fontSize)
            label.textColor = textColor
            label.text = self.titleForSegment(at: index)
            label.numberOfLines = 0
            label.textAlignment = .center
            label.adjustsFontSizeToFitWidth = true
            
            self.setTitle("", forSegmentAt: index)
            self.subviews[index].addSubview(label)
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
                   // If the search bar is empty, display all records
                   filteredData = shopDataDict
               } else {
                   // Filter the data based on the search text
                   filteredData = shopDataDict.filter { $0.productName.lowercased().contains(searchText.lowercased()) }
               }
     
        shopTableview.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Reset the filtered data when cancel button is tapped
        filteredData = shopDataDict
        shopTableview.reloadData()
    }
}
