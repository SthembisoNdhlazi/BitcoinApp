//
//  ViewController.swift
//  BitcoinApp
//
//  Created by IACD-020 on 2022/06/04.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var ltcLabel: UILabel!
    @IBOutlet var lastUpdated: UILabel!
    
    @IBOutlet var usdLabel: UILabel!
    
    @IBOutlet var ethLabel: UILabel!
    
    @IBOutlet var btcLabel: UILabel!
    
    let urlString = "https://api.coingecko.com/api/v3/exchange_rates"
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }

    func fetchData(){
        let url = URL(string: urlString)
        let defaultSession = URLSession(configuration: .default)
        
        let dataTask = defaultSession.dataTask(with:url!){(data:Data?,response:URLResponse?,error:Error?) in
            
            if(error != nil){
                print(error!)
                return
            }
            
            do{
                let json = try JSONDecoder().decode(Rates.self, from: data!)
                self.setPrices(currency:json.rates)
            }catch{
                print(error)
                return
            }
            
        }
        dataTask.resume()
    }
    
    func setPrices(currency:Currency){
        
        DispatchQueue.main.async {
            self.btcLabel.text = self.formatPrice(price: currency.btc)
            self.ethLabel.text = self.formatPrice(price: currency.eth)
            self.usdLabel.text = self.formatPrice(price: currency.usd)
            self.ltcLabel.text = self.formatPrice(price: currency.ltc)
            self.lastUpdated.text = self.formatDate(date: Date())
        }
        
    }
    
    func formatDate(date:Date)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y HH:mm:ss"
        return formatter.string(from: date)
    }
    
    //formats the price and returns it as a String
    func formatPrice(price:Price)-> String{
        return String(format: "%@ %.4f", price.unit, price.value)
    }
    
    //sets the prices to the prices in the JSON
    struct Currency:Codable{
        let btc:Price
        let eth:Price
        let usd:Price
        let aud:Price
        let ltc:Price
    }
    
    //declares the Prices
    struct Price:Codable{
        let name:String
        let unit:String
        let value:Float
        let type:String
        
    }
    
    struct Rates:Codable{
        let rates:Currency
    }

}

