//
//  TripAcceptedView.swift
//  UberCloneSwiftUI
//
//  Created by 수킴 on 2023/08/06.
//

import SwiftUI

struct TripAcceptedView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            Capsule()
                .foregroundColor(Color(.systemGray5))
                .frame(width: 48, height: 6)
                .padding(8)
            
            if let trip = viewModel.trip {
                
                // pickup info view
                VStack {
                    HStack {
                        Text("기사가 \(trip.pickupLocationName)에서 \(trip.dropoffLocationName)로 여정을 진행합니다.")
                            .font(.body)
                            .frame(height: 44)
                            .lineLimit(2)
                            .padding(.trailing)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(trip.travelTimeToPassenger)")
                                .bold()
                            
                            Text("분")
                                .bold()
                        }
                        .frame(width: 56, height: 56)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .cornerRadius(10)
                    }
                    .padding()
                    
                    Divider()
                }
                
                // driver info view
                VStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(trip.driverName)
                                .fontWeight(.bold)
                            
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(.systemYellow))
                                    .imageScale(.small)
                                
                                Text("4.8")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        // driver vehicle info
                        VStack(alignment: .center) {
                            Image("uber-x")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 64)
                            
                            HStack {
                                Text("EF 소나타")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                                
                                Text("36허 1234")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .frame(width: 160)
                            .padding(.bottom)
                        }
                    }
                    
                    Divider()
                }
                .padding()
            }
            
            Button {
                viewModel.cancelTripAsPassenger()
            } label: {
                Text("취소하기")
                    .fontWeight(.bold)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                    .background(.red)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
        }
        .padding(.bottom, 24)
        .background(Color.theme.backgroundColor)
        .cornerRadius(16)
        .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
    }
}

struct TripAcceptedView_Previews: PreviewProvider {
    static var previews: some View {
        TripAcceptedView()
    }
}
