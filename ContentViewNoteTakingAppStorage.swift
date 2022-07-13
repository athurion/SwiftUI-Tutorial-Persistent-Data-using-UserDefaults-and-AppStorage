//
//  ContentView.swift
//  SwiftUI Note taking
//
//  Created by Alvin Sosangyo on 2/23/22.
//


import SwiftUI

/// The best practice is to write these part of code on a separate file.
/// It's only located here for the sake of tutorial.
enum KeyValue: String {
    case selectedFont, fontSize, darkMode, inputText
}


struct ContentView: View {

    @State private var showState: Bool = false
    
    let userDefaults = UserDefaults.standard
    
    @AppStorage(KeyValue.inputText.rawValue) private var inputText: String = ""
    @AppStorage(KeyValue.selectedFont.rawValue) private var selectedFont: String = "Arial"
    @AppStorage(KeyValue.darkMode.rawValue) private var darkMode: Bool = false
    @AppStorage(KeyValue.fontSize.rawValue) private var fontSize: Int = 14
    
    var body: some View {
        
        ZStack {
            
            if darkMode == true {
                Color.black.ignoresSafeArea(.all)
            }
            
            VStack {
                
                TextEditor(text: $inputText)
                    .padding()
                    .font(.custom(selectedFont, size: CGFloat(fontSize)))
                    .onChange(of: inputText) { newValue in
                        userDefaults.set(newValue, forKey: KeyValue.inputText.rawValue)
                    }
                
                Button(action: {
                    showState.toggle()
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 50))
                        .foregroundColor(darkMode ? .white : .black)
                        .background(darkMode ? .black : .white)
                }
                
                Spacer()
                
            } //VStack
            
        } //ZStack
        .sheet(isPresented: $showState) {
            SettingsView(selectedFont: $selectedFont, fontSize: $fontSize, darkMode: $darkMode)
                .onChange(of: selectedFont) { newValue in
                    userDefaults.set(newValue, forKey: KeyValue.selectedFont.rawValue)
                }
                .onChange(of: fontSize) { newValue in
                    userDefaults.set(newValue, forKey: KeyValue.fontSize.rawValue)
                }
                .onChange(of: darkMode) { newValue in
                    userDefaults.set(newValue, forKey: KeyValue.darkMode.rawValue)
                }
        }
        
    } //body
        
} //ContentView


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct SettingsView: View {
    
    let fontList = ["Arial", "Charter", "Futura"]
    @Binding var selectedFont: String
    @Binding var fontSize: Int
    @Binding var darkMode: Bool
    
    var body: some View {
        
        NavigationView {
            
            Form {
                
                Section(header: Text("Font")) {
                    
                    Picker("Font Style", selection: $selectedFont) {
                        ForEach(fontList, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Stepper("Font Size: \(fontSize)", value: $fontSize, in: 7...30)
                    
                }
                
                Section(header: Text("Background")) {
                    
                    Toggle("Dark Mode", isOn: $darkMode)
                    
                }
                
            } //Form
            
        } //NavigationView
        
    } //body
    
} //SettingsView

