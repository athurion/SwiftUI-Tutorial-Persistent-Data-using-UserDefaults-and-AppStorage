//
//  ContentView.swift
//  SwiftUI Note taking
//
//  Created by Alvin Sosangyo on 2/20/22.
//


import SwiftUI

/// The best practice is to write these part of code on a separate file.
/// It's only located here for the sake of tutorial.
enum KeyValue: String {
    case selectedFont, fontSize, darkMode, inputText
}

let userDefaults = UserDefaults.standard
var selectedFontSave = userDefaults.string(forKey: KeyValue.selectedFont.rawValue)
var fontSizeSave = userDefaults.integer(forKey: KeyValue.fontSize.rawValue)
var darkModeSave = userDefaults.bool(forKey: KeyValue.darkMode.rawValue)
var inputTextSave = userDefaults.string(forKey: KeyValue.inputText.rawValue)


struct ContentView: View {

    @State private var inputText: String = inputTextSave ?? ""
    @State private var showState: Bool = false
    @State private var selectedFont: String = selectedFontSave ?? "Arial"
    @State private var darkMode: Bool = darkModeSave
    @State private var fontSize: Int = fontSizeSave == 0 ? 14 : fontSizeSave
    
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
                        userDefaults.set(inputText, forKey: KeyValue.inputText.rawValue)
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
                    userDefaults.set(selectedFont, forKey: KeyValue.selectedFont.rawValue)
                }
                .onChange(of: fontSize) { newValue in
                    userDefaults.set(fontSize, forKey: KeyValue.fontSize.rawValue)
                }
                .onChange(of: darkMode) { newValue in
                    userDefaults.set(darkMode, forKey: KeyValue.darkMode.rawValue)
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

