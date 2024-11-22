//
//  NewStoryView.swift
//  StoryLand-2024
//
//  Created by Ryan Lam on 21/11/2024.
//

import SwiftUI
import PencilKit
import PhotosUI

struct NewStoryView: View {
    @State private var content: String = "Hello"
    private var placeholderString: String = "Hello"
    private var canvasView = PKCanvasView()
    
    @State private var isPresented: Bool = false
    
    @State var color = Color.white
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    
    var inspectorForm: some View {
        VStack(spacing: 20) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()) {
                    Text("Select a photo")
                }
                .onChange(of: selectedItem) { selectedItem in
                    Task {
                        // Retrieve selected asset in the form of Data
                        if let data = try? await selectedItem?.loadTransferable(type: Data.self) {
                            selectedImageData = data
                        }
                    }
                }
            
            ColorPicker("Background Color",
                        selection: $color,
                        supportsOpacity: false)
            
            TextEditor(text: $content)
                .padding()
                .lineSpacing(20)
                .autocapitalization(.words)
                .disableAutocorrection(true)
                .foregroundColor(self.content == placeholderString ? .gray : .primary)
                .onTapGesture {
                    if self.content == placeholderString {
                        self.content = ""
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
        }
        .padding()
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                
            }
           
        } content: {
            inspectorForm
        } detail: {
            VStack {
                MyCanvas(backgroundImage: $selectedImageData, backgroundColor: $color, canvasView: canvasView)
                    
            }
            .ignoresSafeArea()
            .frame(maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

struct MyCanvas: UIViewRepresentable {
    @Binding var backgroundImage: Data?
    @Binding var backgroundColor: Color
    
    var canvasView: PKCanvasView
    let picker = PKToolPicker.init()
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .black)
        self.canvasView.becomeFirstResponder()
        self.canvasView.drawingPolicy = .anyInput
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        picker.addObserver(uiView)
        picker.setVisible(true, forFirstResponder: uiView)

        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }

        uiView.backgroundColor = UIColor(backgroundColor)
        
        if let backgroundImage {
            let imageView = UIImageView(image: UIImage(data: backgroundImage))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            uiView.isOpaque = false
            
            let subView = uiView.subviews[0]
                subView.addSubview(imageView)
                subView.sendSubviewToBack(imageView)
        }
    }
}

#Preview {
    NewStoryView()
}
