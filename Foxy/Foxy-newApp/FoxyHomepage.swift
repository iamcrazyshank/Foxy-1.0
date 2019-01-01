//
//  FoxyHomepage.swift
//  Foxy-newApp
//
//  Created by Shashank Chandran


import UIKit
import SwiftyJSON
import Alamofire


class FoxyHomepage: UICollectionViewController , UICollectionViewDelegateFlowLayout {

    var refresher:UIRefreshControl!
    
    @IBOutlet var FoxyCollectionVC: UICollectionView!
    
    
     var articles: [newsArticle]? = []
  
    override func viewDidLoad() {
       super.viewDidLoad()
        self.refresher = UIRefreshControl()
        self.FoxyCollectionVC!.alwaysBounceVertical = true
        self.refresher.tintColor = UIColor.blue
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.collectionView!.addSubview(refresher)
        
       fetchArticles()
        if let patternImage = UIImage(named: "back") {
            collectionView.backgroundColor = UIColor(patternImage: patternImage)
        }
       self.FoxyCollectionVC.reloadData()
    }
    
 
    @objc func loadData() {
        fetchArticles()
        stopRefresher()         //Call this to stop refresher
    }
    
    func stopRefresher() {
        self.refresher.endRefreshing()
    }
    
    
    func fetchArticles(){
       
        
        Alamofire.request("https://newsapi.org/v2/everything?q=bitcoin&from=2018-12-10&sortBy=publishedAt&apiKey=60a07d6b5b674052a432ec430a83bcc7").response { response in
            let swiftyJsonVar = JSON(response.data as Any)
            print(swiftyJsonVar)
            self.articles = [newsArticle]()
            if let articles = swiftyJsonVar["articles"].arrayObject as? [[String : AnyObject]]{
                 for article in articles {
                     let newArticle = newsArticle()
                        if  let title = article["title"] as? String , let author = article["author"] as? String, let description = article["description"] as? String, let urlToImage = article["urlToImage"] as? String, let posturl = article["url"] as? String {
                        
                        newArticle.author = author
                        newArticle.desc = description
                        newArticle.headline = title
                        newArticle.imageUrl = urlToImage
                        newArticle.postURL = posturl
                        
                    }
                    self.articles?.append(newArticle)
               
                }
                self.FoxyCollectionVC.reloadData()
            }else{
                print("Error in fetching the NEWS JSON")
            }
        }
    }
        
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (articles?.count)!
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath)
        if let newsCell = cell as? NewsViewCell{
           
            if let imageURL = self.articles?[indexPath.item].imageUrl{
                 newsCell.newsImage.downloadImage(from:imageURL)
                newsCell.newsHeadline.text = self.articles![indexPath.item].headline
            }
         
         }
        
        
        cell.layer.borderWidth = 1.4
        
     return cell
    }
 
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       // self.navigationController?.setNavigationBarHidden(false, animated: true)
        let DVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController
        DVC?.newArticle = self.articles![indexPath.item]
        self.navigationController?.pushViewController(DVC!, animated: true)
        
    }
 

}
extension UIImageView {
    
    func downloadImage(from url: String){
        
        Alamofire.request(url).response { response in
            let swiftyJsonVar = response.data
            let imagenew = UIImage(data: swiftyJsonVar!, scale: 1)
           self.image = imagenew
            
        }
    }
}





