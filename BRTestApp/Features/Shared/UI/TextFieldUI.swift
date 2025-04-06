//
//  TextFieldUI.swift
//  BRTestApp
//
//  Created by Ben Roaman on 4/5/25.
//

import SwiftUI

struct TextFieldUI: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextField {
        let result = UITextField(frame: .zero)
        result.delegate = context.coordinator
        return result
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        guard uiView.text != text else { return }
        uiView.text = text
    }
    
    final class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        .init(text: $text)
    }
}
