//
//  ContentView.swift
//  PhotoFrame
//
//  Created by Gian Pinto on 28/10/24.
//

import SwiftUI
import PhotosUI // Import the PhotosUI framework to access the photo library

struct ContentView: View {
    
    @State private var selectedImage: UIImage? // State variable to hold the selected image
    @State private var isImagePickerPresented: Bool = false // State variable to manage the image picker
    
    var body: some View {
        VStack{
            Text("PhotoFrame")// Title at the top
                .font(.largeTitle)// Customize font size
                .padding()
            
            Spacer()// This pushes the following views down
            
            Text("This picture was imported from the camera roll")
                .font(.title)
                .fontWeight(.light)
                .foregroundColor(Color.gray)
                .padding()
            
            
            // Check if an image is selected, if so display it, otherwise show placeholder text
            if let image = selectedImage {
                Image(uiImage: image) // Display the selected image
                    .resizable() // Allow the image to be resized
                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio while fitting in the frame
                    .frame(width: 300, height: 250) // Set the desired size of the image
                    .border(Color.brown, width: 10) // Add a brown border around the image
                    .padding() // Add optional padding around the image
            } else {
                // Placeholder text shown when no image is selected
                Text("No image selected")
                    .font(.title2) // Set the font size for the placeholder text
                    .foregroundColor(Color.gray) // Set the text color to gray
                    .padding() // Add padding around the placeholder text
            }

            Spacer()
            
            // Button to select an image from the camera roll
                        Button(action: {
                            isImagePickerPresented = true // Show the image picker when the button is tapped
                        }) {
                            Text("Select Image from Camera Roll") // Button label
                                .padding() // Add padding around the button text
                                .background(Color.blue) // Set the button background color to blue
                                .foregroundColor(.white) // Set the button text color to white
                                .cornerRadius(8) // Round the corners of the button
                        }
                        .padding() // Add padding around the button
                        // Present the image picker when isImagePickerPresented is true
                        .imagePicker(isPresented: $isImagePickerPresented, selectedImage: $selectedImage)
                    }
                    .padding() // Add padding around the entire VStack
                }
            }

            // Extend View to create a custom Image Picker modifier
            extension View {
                func imagePicker(isPresented: Binding<Bool>, selectedImage: Binding<UIImage?>) -> some View {
                    // Present the ImagePicker as a sheet when isPresented is true
                    self.sheet(isPresented: isPresented) {
                        ImagePicker(selectedImage: selectedImage) // Present the ImagePicker
                    }
                }
            }

            // ImagePicker View
            struct ImagePicker: UIViewControllerRepresentable {
                @Binding var selectedImage: UIImage? // Binding to the selected image

                // Coordinator class to handle interactions with the image picker
                class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
                    var parent: ImagePicker // Reference to the parent ImagePicker

                    init(parent: ImagePicker) {
                        self.parent = parent // Initialize with the parent ImagePicker
                    }

                    // Called when an image is selected
                    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                        if let image = info[.originalImage] as? UIImage {
                            parent.selectedImage = image // Set the selected image in the parent
                        }
                        picker.dismiss(animated: true) // Dismiss the image picker
                    }
                    
                    // Called when the image picker is canceled
                    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                        picker.dismiss(animated: true) // Dismiss the image picker
                    }
                }

                func makeCoordinator() -> Coordinator {
                    Coordinator(parent: self) // Create a Coordinator instance
                }

                // Create the UIImagePickerController
                func makeUIViewController(context: Context) -> UIImagePickerController {
                    let picker = UIImagePickerController() // Create an instance of UIImagePickerController
                    picker.delegate = context.coordinator // Set the delegate to the coordinator
                    picker.sourceType = .photoLibrary // Set the source to the photo library
                    return picker // Return the configured image picker
                }

                // Required method, but we don't need to update the view controller
                func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
            }

#Preview {
    ContentView()
}
