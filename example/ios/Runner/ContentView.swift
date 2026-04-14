//
//  ContentView.swift
//  Runner
//
//  Created by Kian Mehravaran on 13.04.26.
//

import SwiftUI
import Flutter

struct ContentView: View {
    var body: some View {
        FlutterViewControllerRepresentable()
            .ignoresSafeArea()
    }
}

struct FlutterViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> FlutterViewController {
        let vc = FlutterViewController(project: nil, nibName: nil, bundle: nil)
        GeneratedPluginRegistrant.register(with: vc)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: FlutterViewController, context: Context) {}
}
