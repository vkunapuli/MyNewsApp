//
//  NewsCategoryViewController.swift
//  MyNewsApp
//
//  Created by Venkata ramana Kunapuli on 1/19/18.
//  Copyright © 2018 Venkata ramana Kunapuli. All rights reserved.
//

import UIKit

import SafariServices
class NewsCategoryViewCell: UITableViewCell{
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var innerCellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
class NewsCategoryViewController: UITableViewController {
    var category:String?
    var newsURL:String?
    var newsFeeds =  [[String: Any]]()
    var indicator = UIActivityIndicatorView()
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x:0,y:0,width:40,height:40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        indicator.center = self.view.center
        self.view.addSubview(indicator)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let parallaxViewFrame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200)
        let parallaxView = ParallaxHeaderView(frame: parallaxViewFrame)
        parallaxView.parent = self;
        self.tableView.tableHeaderView = parallaxView
        self.tableView.delegate = self
        self.tableView.rowHeight =   UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 116
        let httpService:HttpService = HttpService()
        newsURL =  "https://newsapi.org/v2/top-headlines?country=us&category=" + category! + "&apiKey=9f1515000c9d4d24919d25c44a3b7dc8"
        indicator.startAnimating()
        indicator.backgroundColor = .white
        httpService.doGet(serverMethod: newsURL!, callback: {
            (jsonData: Dictionary<String, Any>?, userResponse: URLResponse?, error: Error?) in
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
            if(error == nil && jsonData != nil){
                self.handleNewsFeeds(jsonData!)
            } else {
                // callback(nil, error)
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //refreshView()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 26/255.0, green: 96/255.0, blue: 172/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(self.tableView.tableHeaderView != nil)
        {
            let headerView = self.tableView.tableHeaderView as! ParallaxHeaderView
            headerView.scrollViewDidScroll(scrollView: scrollView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        var numOfSections: Int = 0
        if (newsFeeds.count > 0)
        {
            tableView.separatorStyle = .none
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else
        {
            let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No data available"
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        guard let urlStr = newsFeeds[indexPath.row]["url"] as? String,  let url =  URL(string:urlStr) else {return}
        NotificationCenter.default.post(name: Notification.Name("NewsDetailsEvent"), object: nil, userInfo: ["url":urlStr])
        //self.dismiss(animated: false, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsFeeds.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCategoryViewCell
        // Configure the cell...
        cell.backgroundColor = UIColor.clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = bgColorView
        cell.innerCellView.layer.cornerRadius = 4
        //cell.shadowView.dropShadow(scale: true)
        cell.titleLabel?.text = newsFeeds[indexPath.row]["title"] as? String
        cell.descriptionLabel?.text = newsFeeds[indexPath.row]["description"] as? String
       // cell.rightImage?.image = nil
        let string = newsFeeds[indexPath.row]["publishedAt"] as? String
        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: string!)!
        let elapsed = Date().timeIntervalSince(date)
        let update = Int(elapsed/60000)
        cell.updateTime.text = "\(update) min"
        //NO image for now , comented the code below
        /*
         guard let imageStr = newsFeeds[indexPath.row]["urlToImage"] as? String ,let imgUrl =  URL(string:imageStr) else{ return cell;}
         ImageManager.downloadImage(url:imgUrl, callback:{(data:Data?) in
         if (data != nil)
         {
         cell.rightImage?.image = UIImage(data: data!)
         }
         })
         */
        return cell
    }
    func handleNewsFeeds(_ feeds:Dictionary<String, Any>)
    {
        if feeds["status"] as! String != "ok"{ return;}
        newsFeeds = feeds["articles"] as! [[String : Any]]
        self.tableView.reloadData()
    }
    
}

final class ParallaxHeaderView: UIView {
    var parent:NewsCategoryViewController!
    
    fileprivate var heightLayoutConstraint = NSLayoutConstraint()
    fileprivate var bottomLayoutConstraint = NSLayoutConstraint()
    fileprivate var containerView = UIView()
    fileprivate var containerLayoutConstraint = NSLayoutConstraint()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    public func setParent(parent:NewsCategoryViewController)
    {
        self.parent = parent
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear //.white
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = UIColor.red
        
        self.addSubview(containerView)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["containerView" : containerView]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[containerView]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil,
                                                           views: ["containerView" : containerView]))
        
        containerLayoutConstraint = NSLayoutConstraint(item: containerView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .height,
                                                       multiplier: 1.0,
                                                       constant: 0.0)
        self.addConstraint(containerLayoutConstraint)
        //let imageView = UIImageView();
        let imageView:UIView = setupView(width: Float(frame.width))
        /*
        let imageName = "images.jpg"
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        imageView.contentMode = UIViewContentMode.scaleAspectFill
 */
        containerView.addSubview(imageView)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[imageView]|",
                                                                    options: NSLayoutFormatOptions(rawValue: 0),
                                                                    metrics: nil,
                                                                    views: ["imageView" : imageView]))
        
        bottomLayoutConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .bottom,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .bottom,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        containerView.addConstraint(bottomLayoutConstraint)
        
        heightLayoutConstraint = NSLayoutConstraint(item: imageView,
                                                    attribute: .height,
                                                    relatedBy: .equal,
                                                    toItem: containerView,
                                                    attribute: .height,
                                                    multiplier: 1.0,
                                                    constant: 0.0)
        
        containerView.addConstraint(heightLayoutConstraint)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerLayoutConstraint.constant = scrollView.contentInset.top;
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top);
        containerView.clipsToBounds = offsetY <= 0
        bottomLayoutConstraint.constant = offsetY >= 0 ? 0 : -offsetY / 2
        heightLayoutConstraint.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
    func setupView(width: Float) -> UIView{
        let view:UIView = UIView();
        let image =  #imageLiteral(resourceName: "newsImage")//UIImage(named: "blog6.jpg")!
        
        view.backgroundColor =  UIColor(patternImage: image.resizeImage(newWidth:CGFloat(width)))
        view.translatesAutoresizingMaskIntoConstraints = false
        /*
        //Image View
        let imageView = UIImageView()
        imageView.heightAnchor.constraint(equalToConstant: 80.0).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
        if let image = ImageManager.getSavedImage(imageName: "fileName")
        {
            imageView.image = image
        }
        else
        {
            imageView.image = UIImage(named: "Portfolio_Icon")!
        }
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40.0
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        
        let loginButton = UIButton()
        loginButton.setTitle(NSLocalizedString("SIGN IN", comment: "SIGN IN"), for: .normal)
        loginButton.backgroundColor = UIColor(red: 236/255.0, green: 75/255.0, blue: 43/255.0, alpha: 1.0)
        loginButton.tintColor = UIColor.white
        loginButton.layer.cornerRadius = 22
        loginButton.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        loginButton.addTarget(parent, action: #selector(parent.authenticationWithTouchID), for: .touchUpInside)
        
        
        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing   = 16.0
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(loginButton)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        */
        
        //Constraints
        /*
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
         */
        return view
    }
}

