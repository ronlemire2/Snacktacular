//
//  SpotDetailView.swift
//  Snacktacular
//
//  Created by Ron Lemire on 10/18/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SpotDetailView: View {
    @FirestoreQuery(collectionPath: "spots") var fsPhotos: [Photo]
    // The variable below doesn't have the right path. We'll change this in .onAppear.
    @FirestoreQuery(collectionPath: "spots") var reviews: [Review]
    @State var spot: Spot  // pass in value from ListView
    @State private var photoSheetIsPresented = false
    @State private var showingAlert = false // Alert user if they need to save Spot before adding a Photo
    @State private var alertMessage = "Cannot add a Phot until you save the Spot."
    @State private var showReviewViewSheet = false
    @Environment(\.dismiss) private var dismiss
    private var photos: [Photo] {
        // If running in Preview then show mock data
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return [Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview,Photo.preview]
        }
        // Else show Firebase Data
        return fsPhotos
    }
    var previewRunning = false
     
    var body: some View {
        VStack {
            Group {
                TextField("name", text: $spot.name)
                    .font(.title2)
                    .autocorrectionDisabled()
                
                TextField("address", text: $spot.address)
                    .font(.title2)
                    .autocorrectionDisabled()
            }
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            Button { // Photo Button
                if spot.id == nil { // Ask if you want to save
                    showingAlert.toggle()
                } else { // Go right to Photoview
                    photoSheetIsPresented.toggle()
                }
            } label: {
                Image(systemName: "camera.fill")
                Text("Photo")
            }
            .bold()
            .buttonStyle(.borderedProminent)
            .tint(.snack)
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(photos) { photo in
                        let url = URL(string: photo.imageURLString)
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }

                    }
                }
            }
            .frame(height: 80)
            
            Text("< Map goes here >")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundStyle(.red)
                .frame(height:150)
                .frame(maxWidth: .infinity)
                .background(Color.cyan)
                .padding(.horizontal)
            
            List {
                Section {
                    ForEach(reviews) { review in
                        NavigationLink {
                            ReviewView(spot: spot, review: review)
                        } label: {
                            Text(review.title) //TODO: Build a custom cell showing stars, title, and body
                        }
                    }
                } header: {
                    HStack {
                        Text("Avg. Rating:")
                            .font(.title2)
                            .bold()
                        Text("4.5") //TODO: Change to a computer property
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundStyle(Color("SnackColor"))
                        Spacer()
                        Button("Rate It") {
                            showReviewViewSheet.toggle()
                        }
                        .buttonStyle(.borderedProminent)
                        .bold()
                        .tint(Color("SnackColor"))
                    }
                }
                .headerProminence(.increased)
            }
            .listStyle(.plain)
            
            Spacer()
        }
        .sheet(isPresented: $showReviewViewSheet, content: {
            NavigationStack {
                ReviewView(spot: spot, review: Review())
            }
        })
        .onAppear() { // This is to prevent PreviewProvider error!
            // Gallaugher' preview was crashing so he created 'previewRunning' switch to get around it.
            if !previewRunning {
                //TODO: replace spot.id with guard let spotID
                /*
                 guard let spotID = spot.id else {
                    print("ERROR: spot.id = nil")
                 */
                $reviews.path = "spots/\(spot.id ?? "abc")/reviews" //TODO: replace with guard let
                print("reviews.path = \($reviews.path)")
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            //TODO: replace spot.id with guard let spotID
            /*
             guard let spotID = spot.id else {
                print("ERROR: spot.id = nil")
             */
            $fsPhotos.path = "spots/\(spot.id ?? "xyz")/photos"
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveSpot()
                    dismiss()
                }
            }
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                // We want to return spot.id after saving a new Spot. Right now it's nil.
                Task {
                    guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                        print("ERROR: Saving spot in alert returned nil")
                        return
                    }
                    spot.id = id
                    print("spot.id: \(id)")
                    photoSheetIsPresented.toggle() // Now open sheet & move to PhotoView
                }
            }
        }
        .fullScreenCover(isPresented: $photoSheetIsPresented) {
            PhotoView(spot: spot)
        }
    }
    
    func saveSpot() {
        Task {
            guard let id = await SpotViewModel.saveSpot(spot: spot) else {
                print("ERROR: Saving spot from Save button")
                return
            }
            print("spot.id: \(id)")
            print("Nice Spot saved!")
        }
    }
}

#Preview {
    NavigationStack {
        SpotDetailView(spot: Spot.preview, previewRunning: true)
    }
}
