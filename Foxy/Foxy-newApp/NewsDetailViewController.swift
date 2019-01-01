//
//  NewsDetailViewController.swift
//  Foxy-newApp
//
//  Created by Shashank Chandran 
//

import UIKit
import Alamofire

class NewsDetailViewController: UIViewController {
    
    var newArticle = newsArticle()
    
    var postUrl: String?
    
    @IBOutlet weak var DetailNewsImage: UIImageView!
    @IBOutlet weak var DetailNewsAuthor: UILabel!
    @IBOutlet weak var DetailNewsBody: UILabel!
    @IBOutlet weak var DetailNewstitle: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // googleButton.addTarget(self, action: "readMore", forControlEvents: .TouchUpInside)
           DetailNewsAuthor.text = newArticle.author
            DetailNewstitle.text = newArticle.headline
             DetailNewsBody.text = newArticle.desc
        
        if let imageURL = newArticle.imageUrl{
            DetailNewsImage.DownloadDetailimage(from:imageURL)
        }
      DetailNewstitle.adjustsFontSizeToFitWidth = true
        DetailNewsAuthor.adjustsFontSizeToFitWidth = true
        
    }
    
    @IBAction func readMore(_ sender: Any) {
   
        if let url = NSURL(string: (newArticle.postURL!) as String){
            UIApplication.shared.open(url as URL, options: [:])
        }
    
    }
    
}


extension UIImageView {
    
    func DownloadDetailimage(from url: String){
        
        Alamofire.request(url).response { response in
            let swiftyJsonVar = response.data
            let imagenew = UIImage(data: swiftyJsonVar!, scale: 1)
            self.image = imagenew
            
        }
    }
}
