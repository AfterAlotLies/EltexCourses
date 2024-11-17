//
//  NewsModel.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

struct NewsModel: Codable {
    private enum CodingKeys: String, CodingKey {
        case title
        case dataPublished = "publishedAt"
        case author
        case content
    }
    
    let title: String
    let dataPublished: String
    let author: String?
    let content: String
}

struct ArticlesModel: Codable {
    let articles: [NewsModel]
}
