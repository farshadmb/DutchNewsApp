//
//  ModelsDataFactory.swift
//  DutchNewsTests
//
//  Created by Farshad Mousalou on 9/20/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import Foundation

@testable import DutchNewsTests

struct ModelsDataFactory {
    
    //swiftlint:disable all
    static func createMockArticlesData() -> Data {
        let bundle = Bundle(for: ModelTests.self)
       return try! Data(contentsOf: bundle.url(forResource: "Articles", withExtension: "json")!)
    }
    
    static func createCorruptedMockArticlesData() -> Data {
        return """
            [{
               "source": {
                   "id": null,
                   "name": "Rtlboulevard.nl"
               },
               "author": null,
               "title": "Vriendin Tommie Christiaan in verwachting - RTL Boulevard",
               "description": "'Vandaag op ons 2-jarige jubileum willen we graag met iedereen delen dat we papa en mama worden', zo maakt Tommie Christiaan (34) vandaag dolblij bekend dat hij binnenkort vader wordt.",
               "url": "https://www.rtlboulevشسیضصثضصثضصثard.nl/entertainment/showbizz/artikel/5184898/vriendin-tommie-christiaan-verwachting-van-een-kleintje",
               "urlToImage": "https://www.rtlboulevard.nl/sites/default/files/styles/liggend_hoge_resolutie/public/content/images/2020/09/20/Tommie%20Christiaan.jpg?h=a9edb586&itok=0sJngmbZ",
               "publishedAt": "2020-09-20T09:50:39Z",
               "content": "De musicalster deelt het leuke nieuwtje op zijn Instagram met daarbij een foto van de buik van zijn vriendin. 'Onze grootste wens komt uit en we zijn zo dankbaar en gelukkig dat we dit mogen meemaken… [+583 chars]"
           },
           {
               "source": {
                   "id": null,
                   "name": "Voetbalprimeur.nl"
               },
               "author": null,
               "title": "LIVE-discussie: gewijzigd ADO en Groningen jagen op eerste Eredivisie-zege - VoetbalPrimeur.nl",
               "description": "ADO Den Haag begint zondag flink gewijzigd aan de eerste thuiswedstrijd van het seizoen in de Eredivisie. Trainer Aleksandr Rankovic geeft onder meer nieuweling Lassana Faye een basisplaats tegen FC Groningen, dat het nog moet stellen zonder Arjen Robben.",
               "url": "https://www.voetbalprimeur.nl/nieuws/945567/live-discussie-gewijzigd-ado-en-groningen-jagen-op-eerste-eredivisie-zege.html",
               "urlToImage": "https://files.voetbalprimeur.nl/social/2020/09/20/social_07e16002d68daebaf4ab8f699774e501d8928da7.jpg",
               "publishedAt": "2020-09-20T09:45:51Z",
               "content": "ADO Den Haag begint zondag flink gewijzigd aan de eerste thuiswedstrijd van het seizoen in de Eredivisie. Trainer Aleksandr Rankovic geeft onder meer nieuweling Lassana Faye een basisplaats tegen FC … [+1046 chars]"
           },
           {
               "source": {
                   "id": null,
                   "name": "Racesport.nl"
               },
               "author": "https://www.facebook.com/asse.klein",
               "title": "Van der Mark wint Superpole Race voor Rea en Baz in Catalunya - Racesport.nl",
               "description": "Michael van der Mark rijdt een geweldige wedstrijd en wint de Superpole Race op het Circuit de Barcelona-Catalunya door Jonathan Rea achter zich te houden.",
               "url": "https://www.racesport.nl/van-der-mark-wint-superpole-race-voor-rea-en-baz-in-catalunya/",
               "urlToImage": "https://www.racesport.nl/wp-content/uploads/2020/09/IMG_6975.jpg",
               "publishedAt": "2020-09-20T09:33:52Z",
           },
           {
               "source": {
                   "id": null,
                   "name": "Www.nu.nl"
               },
               "author": "NU.nl",
               "description": "Het horloge dat vlak voor het doodschieten van de 24-jarige Bas van Wijk in Amsterdam werd buitgemaakt, is een namaak-Rolex. Dat laat het Openbaar Ministerie (OM) zondag aan NU.nl weten na berichtgeving door het Parool. Mogelijk is Van Wijk doodgeschoten omda…",
               "url": "udp://www.nu.nl/binnenland/6078647/bij-dodelijke-schietpartij-bas-van-wijk-buitgemaakt-horloge-was-nep-rolex.html",
               "urlToImage": "https://media.nu.nl/m/34wxnz3adstc_wd1280.jpg/bij-dodelijke-schietpartij-bas-van-wijk-buitgemaakt-horloge-was-nep-rolex.jpg",
               "publishedAt": "2020-09-20T09:30:00Z",
               "content": "Het horloge dat vlak voor het doodschieten van de 24-jarige Bas van Wijk in Amsterdam werd buitgemaakt, is een namaak-Rolex. Dat laat het Openbaar Ministerie (OM) zondag aan NU.nl weten na berichtgev… [+1614 chars]"
           }
        ]
        """.data(using: .utf8)!
    }
    
    static func createMockArticlesDataWithCorruptedSources() -> Data {
        return """
                    [{
            "source": {
                "id": null
            },
            "author": "ANP",
            "title": "Trump geeft 'zegen' aan bod Oracle op TikTok - Telegraaf.nl",
            "description": "De Amerikaanse president Donald Trump staat achter het bod van Oracle op de Amerikaanse activiteiten van de Chinese filmpjesapp TikTok. „Ik heb de deal mijn zegen gegeven”, zei Trump zaterdag volgens Bloomberg tegen verslaggevers toen hij het Witte Huis verli…",
            "url": "https://www.telegraaf.nl/financieel/1442448989/trump-geeft-zegen-aan-bod-oracle-op-tik-tok",
            "urlToImage": "https://www.telegraaf.nl/images/1200x630/filters:format(jpeg):quality(80)/cdn-kiosk-api.telegraaf.nl/6409f6dc-fb2c-11ea-acba-02c309bc01c1.jpg",
            "publishedAt": "2020-09-20T10:32:00Z",
            "content": "Het nieuwe bedrijf, dat volgens minister van Financiën Steven Mnuchin TikTok Global zou gaan heten, is het resultaat van een transactie die vorige maand door Trump werd afgedwongen vanwege bezorgdhei… [+1099 chars]"
        },
        {
            "source": {
                "id": null,
                "name": "Nos.nl"
            },
            "author": null,
            "title": "Privégegevens Wit-Russische politiemensen online in aanloop naar nieuw protest - NOS",
            "description": "Hackers dreigen de gegevens van nog veel meer politiemensen te publiceren zolang het hardhandige optreden tegen demonstranten doorgaat.",
            "url": "https://nos.nl/l/2349125",
            "urlToImage": "https://nos.nl/data/image/2020/09/20/677152/xxl.jpg",
            "publishedAt": "2020-09-20T10:15:00Z",
            "content": "Hackers hebben privégegevens van ongeveer 1000 Wit-Russische politiemensen gelekt als vergelding voor het arresteren van bijna 400 deelnemers aan de vrouwenmars van gisteren. Ook vandaag gaan Wit-Rus… [+514 chars]"
        },
        {
            "source": {
                "id": null,
            },
            "author": "Mark Hendrikman",
            "title": "Sony: pre-orderproces PlayStation 5 kon veel soepeler gaan - Tweakers",
            "description": "Sony heeft op Twitter zijn excuses aangeboden voor de moeite die klanten hebben met een pre-order plaatsen van de PlayStation 5. \"Dat kon veel soepeler gaan\", stelt het Japanse bedrijf. Verder geeft het garanties wat betreft voorraden in de rest van het jaar.",
            "url": "https://tweakers.net/nieuws/172394/sony-pre-orderproces-playstation-5-kon-veel-soepeler-gaan.html",
            "urlToImage": "https://tweakers.net/i/nmiumjECtV-28XAWh4xU09LWx6c=/67x67/filters:strip_exif()/i/2002904894.png?f=fpa",
            "publishedAt": "2020-09-20T09:51:39Z",
            "content": "Met al die scalpers en bots maak je als normale consument geen schijn van kans.Alsof het normaal is te noemen dat bijv. Bol (en elke andere webwinkel op coolblue na) compleet uitverkocht raakte in lu… [+855 chars]"
        }]
        """
            .data(using: .utf8)!
    }
    
    static func createMockSource() -> Data {
        return "{ \"id\": null, \"name\": \"Telegraph\" }".data(using: .utf8)!
    }
    
    static func createCorruptedMockSource() -> Data {
        return "{ \"id\": null }".data(using: .utf8)!
    }
    //swiftlint: disable enable

}
