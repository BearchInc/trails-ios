import UIKit

class StartupViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }

    private func login() {
        Account.instance.login { (account, errorType) -> () in
            if account != nil {
                print(account)
                self.navigateToHomeViewController()
            } else {
                print(errorType.debugDescription)
                self.showRetry()
            }
        }
    }

    private func retryLoginAction(action: UIAlertAction!) {
        login()
    }

    private func navigateToHomeViewController() {
        self.performSegueWithIdentifier("GoToHomeViewController", sender: self)
    }

    private func showRetry() {
        let alert = UIAlertController(title: "Whoops! Someone stole the Internet",
                message: "Would you like to retry it?",
                preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: retryLoginAction))
        presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}