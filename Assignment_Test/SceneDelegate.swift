//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // The `window` property is an optional UIWindow that serves as the root view controller of the scene.
    var window: UIWindow?


    // This method is called when the scene is about to be connected to a session.
    // It is used to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        // Configure the scene here.
    }

    // This method is called as the scene is being released by the system.
    // It is used to release any resources associated with this scene that can be re-created the next time the scene connects.
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.

        // Release resources here.
    }

    // This method is called when the scene has moved from an inactive state to an active state.
    // It is used to restart any tasks that were paused when the scene was inactive.
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.

        // Restart tasks here.
   
