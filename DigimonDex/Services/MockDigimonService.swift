//
//  MockDigimonService.swift
//  DigimonDex
//
//  Created by Valencia Sutanto on 15/04/26.
//

import Foundation

final class MockDigimonService: DigimonServiceProtocol {

    func fetchList(page: Int, pageSize: Int, filter: FilterOptions) async throws -> DigimonListResponse {
        DigimonListResponse(
            content: [
                DigimonListItem(id: 1, name: "Agumon", href: "", image: "https://digi-api.com/images/digimon/agumon.png"),
                DigimonListItem(id: 2, name: "Gabumon", href: "", image: "https://digi-api.com/images/digimon/gabumon.png")
            ],
            pageable: Pageable()
        )
    }

    func fetchDetail(id: Int) async throws -> DigimonDetail {
        DigimonDetail(
            id: 1,
            name: "Agumon",
            xAntibody: false,
            images: [DigimonImage(href: "https://digi-api.com/images/digimon/agumon.png", transparent: true)],
            levels: [LevelItem(id: 3, level: "Rookie")],
            types: [TypeItem(id: 1, type: "Vaccine")],
            attributes: [AttributeDetailItem(id: 1, attribute: "Fire")],
            fields: [FieldItem(id: 1, field: "Metal Empire", image: "")],
            descriptions: [
                Description(origin: "Reference Book", language: "en_us",
                            description: "A Dinosaur Digimon whose cranial skin has hardened so that it is covered in golden horn-like protuberances.")
            ],
            skills: [
                Skill(id: 1, skill: "Pepper Breath", translation: "",
                      description: "Shoots a fireball from its mouth.")
            ],
            priorEvolutions: [
                Evolution(id: 1, digimon: "Koromon", condition: nil,
                          url: "", image: "https://digi-api.com/images/digimon/koromon.png")
            ],
            nextEvolutions: [
                Evolution(id: 1, digimon: "Greymon", condition: nil,
                          url: "", image: "https://digi-api.com/images/digimon/greymon.png")
            ]
        )
    }
}
