//
//  RecentTipCardView.swift
//  Sehaty
//
//  Created by mohamed hammam on 10/07/2025.
//
import SwiftUI

// MARK: - Recent Tip Card View
struct TipListCardView: View {
    let item: TipsAllItem
    var isSelected: Bool = false
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.title ?? "")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.trailing)
                    .lineLimit(2)
                
                HStack {
                    Text("29/7/2023")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("أمراض الجلد")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 80, height: 80)
                
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 80, height: 80)
                }
                
                Image(systemName: "person.fill")
                    .font(.title2)
                    .foregroundColor(.orange)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}
