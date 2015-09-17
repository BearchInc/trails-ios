import UIKit
import SwiftyDropbox
import Koloda
import pop
import ObjectMapper

private let frameAnimationSpringBounciness:CGFloat = 9
private let frameAnimationSpringSpeed:CGFloat = 16

class HomeViewController: UIViewController, KolodaViewDataSource, KolodaViewDelegate {
    
    @IBOutlet weak var kolodaView: TrailView!
    @IBOutlet weak var toggleDropboxLink: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var trails: [Trail]!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if verifyDropboxAuthorization() {
            evaluateTrails()
        }
    }
    
    func evaluateTrails() {
        activityIndicator.startAnimating()
        Trail.nextEvaluation { (trails: [Trail]?, errorType: ErrorType?) -> Void in
            self.activityIndicator.stopAnimating()
            if errorType != nil {
                print(errorType.debugDescription)
                return
            }

            if let _ = self.trails {
                self.trails! += trails!
                self.showTrails()
                self.kolodaView.reloadData()
            } else {
                self.trails = trails!
                self.showTrails()
            }
            
        }
    }
    
    func showTrails() {
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.alphaValueSemiTransparent = 0.1
        kolodaView.countOfVisibleCards = 3
        self.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(SwipeResultDirection.Right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    //MARK: KolodaViewDataSource
    func kolodaNumberOfCards(koloda: KolodaView) -> UInt {
        return UInt(self.trails.count)
    }
    
    func kolodaViewForCardAtIndex(koloda: KolodaView, index: UInt) -> UIView {
        let cardView = NSBundle.mainBundle().loadNibNamed("CardView",
        owner: self, options: nil)[0] as! CardView

        cardView.render(trails[Int(index)])
        return cardView
    }
    
    func kolodaViewForCardOverlayAtIndex(koloda: KolodaView, index: UInt) -> OverlayView? {
        return NSBundle.mainBundle().loadNibNamed("CustomOverlayView",
            owner: self, options: nil)[0] as? OverlayView
    }
    
    func kolodaDidSwipedCardAtIndex(koloda: KolodaView, index: UInt, direction: SwipeResultDirection) {
        if Int(index) >= trails.count {
            print("What the fuck is happening!!")
            return
        }
        
        let trail = trails[Int(index)]
        switch direction{
        case .Right:
            trail.didLikeItem()
        case .Left:
            trail.didDislikeItem()
            
        default:
            print("Are you serious?")
        }
    }
    
    func kolodaDidRunOutOfCards(koloda: KolodaView) {
        evaluateTrails()
    }
    
    func kolodaDidSelectCardAtIndex(koloda: KolodaView, index: UInt) {
        //do something magical here
    }
    
    func kolodaShouldApplyAppearAnimation(koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaBackgroundCardAnimation(koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation.springBounciness = frameAnimationSpringBounciness
        animation.springSpeed = frameAnimationSpringSpeed
        return animation
    }
    
    func verifyDropboxAuthorization() ->  Bool {
        if let authorizedClient = Dropbox.authorizedClient {
            
            let dropboxAccessTokens = DropboxAuthManager.sharedAuthManager.getAllAccessTokens().keys

            if dropboxAccessTokens.count > 0 {
                toggleDropboxLink.title = "Unlink from Dropbox"
                
                let userId = dropboxAccessTokens.reverse().first!
                let authToken = DropboxAuthManager.sharedAuthManager.getAccessToken(userId)
                
                Account.instance.registerDropbox(userId, accessToken: authToken!.description)
                authorizedClient.usersGetCurrentAccount().response { response, error in
                    if let account = response {
                        Account.instance.update(account)
                    } else {
                        print(error!)
                    }
                }
                
                return true
            } else {
                Dropbox.unlinkClient()
                sleep(1)
                return verifyDropboxAuthorization()
            }
        }
        toggleDropboxLink.title = "Link with Dropbox"
        return false
    }
    
    @IBAction func didTapDropboxLink(sender: AnyObject) {
        if let _ = Dropbox.authorizedClient {
            Dropbox.unlinkClient()
            verifyDropboxAuthorization()
        } else {
           Dropbox.authorizeFromController(self)
        }
    }
    
    @IBAction func linkButtonPressed(sender: AnyObject) {
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        } else {
            print("User is already authorized!")
        }
    }
}
