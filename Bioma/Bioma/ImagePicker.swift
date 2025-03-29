//
//  ImagePicker.swift
//  Bioma
//
//  Created by Velia Isaura Gonzalez Del Angel on 27/03/25.
//


import SwiftUI
import UIKit

// ImagePicker representa el selector de imágenes que se utiliza con el .sheet en RegistrarReporteView.
struct ImagePicker: View {
    @Binding var image: UIImage?  // Vínculo a la imagen seleccionada
    
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack {
            Button("Seleccionar Imagen") {
                isImagePickerPresented.toggle()
            }
            .padding()
            
            if let selectedImage = image {
                Image(uiImage: selectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .cornerRadius(10)
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePickerController(image: $image)
        }
    }
}

// ImagePickerController es un controlador de UIKit para presentar el selector de imágenes.
struct ImagePickerController: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        @Binding var image: UIImage?
        
        init(image: Binding<UIImage?>) {
            _image = image
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                image = selectedImage
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(image: $image)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary  // También puedes usar .camera si deseas permitir tomar fotos
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
