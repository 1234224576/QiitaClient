//
//  TutorialViewController.swift
//  QiitaClieant
//
//  Created by 曽和修平 on 2015/08/09.
//  Copyright (c) 2015年 曽和修平. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController,MYIntroductionDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create stock panel with header
//        UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TestHeader" owner:nil options:nil][0];
        let headerView :UIView = NSBundle.mainBundle().loadNibNamed("TutorialHeader", owner: nil, options: nil)[0] as! UIView
        
        let panel1 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "aa", description: "abcdefghihkmln", header: nil)
        let panel2 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "aa", description: "abcdefghihkmln", header: nil)
        
        let panels = [panel1,panel2]
        let introductionView = MYBlurIntroductionView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        introductionView.delegate = self
        introductionView.setBackgroundColor(UIColor.redColor())
//        introductionView.BackgroundImageView.image = [UIImage imageNamed:@"Toronto, ON.jpg"];
        introductionView.buildIntroductionWithPanels(panels)
        self.view.addSubview(introductionView)

    }
    
//    -(void)introduction:(MYBlurIntroductionView *)introductionView didChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex{
//    NSLog(@"Introduction did change to panel %ld", (long)panelIndex);
//    
//    //You can edit introduction view properties right from the delegate method!
//    //If it is the first panel, change the color to green!
//    if (panelIndex == 0) {
//    [introductionView setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:175.0f/255.0f blue:113.0f/255.0f alpha:0.65]];
//    }
//    //If it is the second panel, change the color to blue!
//    else if (panelIndex == 1){
//    [introductionView setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:79.0f/255.0f blue:133.0f/255.0f alpha:0.65]];
//    }
//    }
//    
//    -(void)introduction:(MYBlurIntroductionView *)introductionView didFinishWithType:(MYFinishType)finishType {
//    NSLog(@"Introduction did finish");
//    }
    
    func introduction(introductionView: MYBlurIntroductionView!, didFinishWithType finishType: MYFinishType) {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let controller: LoginViewController = storyboard.instantiateInitialViewController() as! LoginViewController
        self.presentViewController(controller, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
