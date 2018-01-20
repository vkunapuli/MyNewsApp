//
//  NewsPageViewController
//  MyNewsApp
//
//  Created by Venkata ramana Kunapuli on 1/19/18.
//  Copyright © 2018 Venkata ramana Kunapuli. All rights reserved.
//

import SafariServices
public enum PageMenuOption {
    case selectionIndicatorHeight(CGFloat)
    case menuItemSeparatorWidth(CGFloat)
    case scrollMenuBackgroundColor(UIColor)
    case viewBackgroundColor(UIColor)
    case bottomMenuHairlineColor(UIColor)
    case selectionIndicatorColor(UIColor)
    case menuItemSeparatorColor(UIColor)
    case menuMargin(CGFloat)
    case menuItemMargin(CGFloat)
    case menuHeight(CGFloat)
    case selectedMenuItemLabelColor(UIColor)
    case unselectedMenuItemLabelColor(UIColor)
    case useMenuLikeSegmentedControl(Bool)
    case menuItemSeparatorRoundEdges(Bool)
    case menuItemFont(UIFont)
    case menuItemSeparatorPercentageHeight(CGFloat)
    case menuItemWidth(CGFloat)
    case enableHorizontalBounce(Bool)
    case addBottomMenuHairline(Bool)
    case menuItemWidthBasedOnTitleTextWidth(Bool)
    case titleTextSizeBasedOnMenuItemWidth(Bool)
    case scrollAnimationDurationOnMenuItemTap(Int)
    case centerMenuItems(Bool)
    case hideTopMenuBar(Bool)
}
class NewsPageViewController: UIViewController {
    
    var pageMenu : PageMenu?
    var controllerArray : [UIViewController] = []
    var categories = ["general","technology", "sports", "business", "health", "entertainment", "science"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor =  UIColor(patternImage: UIImage(named: "images.jpg")!)
        for category in categories
        {
            let loginView = storyboard?.instantiateViewController(withIdentifier: "NewsCategory") as? NewsCategoryViewController
            loginView?.category = category
            loginView?.title = category
            controllerArray.append(loginView!)
        }
        
        
        // Initialize page menu with controller array, frame, and optional parameters
        pageMenu = PageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0, y: 20.0, width: self.view.frame.width, height: self.view.frame.height), options: nil)
        //pageMenu?.viewBackgroundColor = UIColor(patternImage: UIImage(named: "Bluebg.png")!)
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        NotificationCenter.default.addObserver(self, selector: #selector(self.newsDetailsReqEvent(notification:)), name: Notification.Name("NewsDetailsEvent"), object: nil)
        
    }
    @objc func newsDetailsReqEvent(notification: Notification){
        let data:[String:String] = notification.userInfo as! [String : String]
        let  url =  URL(string:data["url"]!)
        let svc = SFSafariViewController(url: url!)
        self.present(svc, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    // MARK: UIPageViewControllerDataSource
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
