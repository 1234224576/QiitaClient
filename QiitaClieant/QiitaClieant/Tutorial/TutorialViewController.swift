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
        //tutorial1
        
        let panel1 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "ようこそ！",description: "\nQiitaクライアント茂をダウンロードして下さりありがとうございます！\n茂はiPhoneでもiPadでも使用することができます！")
        
        let panel2 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "使い方〜iPhone・iPad共通〜",description: "\n画面左上のハンバーガーマークをタップするとメニューが表示されます。\n\n自分のプロフィールの部分をタップすると、ログアウトすることができます。\nパスワードを変更した時などはここから再度ログインしなおして下さい！", image: UIImage(named: "tutorial1"))
        
        let panel3 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "使い方〜iPhone・iPad共通〜", description: "\n記事を読んでいる時は、<マークをタップすると記事一覧に戻ることができます。\n左から右へのスワイプでもOKです。", image: UIImage(named: "tutorial2"))
        
        let panel4 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "使い方〜iPhone・iPad共通〜",description: "\nこのクライアントから記事をストックすることができます！\nストックしたい記事のセルをスワイプしてください！\n自分のストックした記事を表示している時は同じ操作でストックを解除になります。", image: UIImage(named: "tutorial_add"))
        
        let panel5 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "使い方〜iPad〜", description: "\niPadではこのようにメニューと記事が同時に表示されます。\nこの時、右側をタップもしくはスワイプするとメニューが消えます。", image: UIImage(named: "tutorial3"))
        
        let panel6 = MYIntroductionPanel(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), title: "使い方〜iPad〜", description: "\nこのようにiPadの大きな画面を目一杯使えます！\nメニューを表示したいときは右から左へスワイプしてください！\nもちろん、左上の<を押しても表示されます。\n\nチュートリアルは以上です！", image: UIImage(named: "tutorial4"))
        
        let panels = [panel1,panel2,panel3,panel4,panel5,panel6]
        let introductionView = MYBlurIntroductionView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        introductionView.delegate = self
        introductionView.setBackgroundColor(Const().baseColor)
        introductionView.buildIntroductionWithPanels(panels)
        self.view.addSubview(introductionView)

    }
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
