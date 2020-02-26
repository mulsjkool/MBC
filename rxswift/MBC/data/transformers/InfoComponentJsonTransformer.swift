//
//  InfoComponentJsonTransformer.swift
//  MBC
//
//  Created by Dung Nguyen on 3/13/18.
//  Copyright © 2018 MBC. All rights reserved.
//

import SwiftyJSON

class InfoComponentJsonTransformer: JsonTransformer {
    let infoComponentElementJsonTransformer: InfoComponentElementJsonTransformer
    
    init(infoComponentElementJsonTransformer: InfoComponentElementJsonTransformer) {
        self.infoComponentElementJsonTransformer = infoComponentElementJsonTransformer
    }
    
    private static let fields = (
        entityId : "entityId",
        type : "type",
        aboveMetadata :"aboveMetadata",
        title : "title",
        showDataOnStream: "showDataOnStream",
        showSubtypeOnFO : "showSubtypeOnFO",
        showCurrentPageMetadata : "showCurrentPageMetadata",
        infoElements : "infoComponentElements"
    )
    
    func transform(json: JSON) -> InfoComponentEntity {
        
        let fields = InfoComponentJsonTransformer.fields
        let entityId = json[fields.entityId].string ?? ""
        let type = json[fields.type].string ?? ""
        let aboveMetadata = json[fields.aboveMetadata].bool ?? false
        let title = json[fields.title].string ?? ""
        let showDataOnStream = json[fields.showDataOnStream].bool ?? false
        let showSubtypeOnFO = json[fields.showSubtypeOnFO].bool ?? false
        let showCurrentPageMetadata = json[fields.showCurrentPageMetadata].bool ?? false
        let infoArray = json[fields.infoElements] == JSON.null ? nil :
            json[fields.infoElements].arrayValue.map { infoComponentElementJsonTransformer.transform(json: $0) }
        return InfoComponentEntity(entityId: entityId, type: type,
                                    aboveMetadata: aboveMetadata, title: title,
                                    showDataOnStream: showDataOnStream, showSubtypeOnFO: showSubtypeOnFO,
                                    showCurrentPageMetadata: showCurrentPageMetadata,
                                    infoComponentElements: infoArray)
    }
}

class ListInfoComponetJsonTransformer: JsonTransformer {
    
    let componentJsonTransformer: InfoComponentJsonTransformer
    
    init(componentJsonTransformer: InfoComponentJsonTransformer) {
        self.componentJsonTransformer = componentJsonTransformer
    }
    
    func transform(json: JSON) -> [InfoComponentEntity] {
        return json.arrayValue.map { componentJsonTransformer.transform(json: $0) }
    }
}

class InfoComponentElementJsonTransformer: JsonTransformer {
    
    let linkedPageJsonTransformer: PageJsonTransformer
    let linkedValueJsonTransformer: LinkedValueJsonTransformer
    let linkedCharacterPageJsonTransformer: LinkedCharacterPageJsonTransformer
    
    init(linkedPageJsonTransformer: PageJsonTransformer,
         linkedValueJsonTransformer: LinkedValueJsonTransformer,
         linkedCharacterPageJsonTransformer: LinkedCharacterPageJsonTransformer) {
        self.linkedPageJsonTransformer = linkedPageJsonTransformer
        self.linkedValueJsonTransformer = linkedValueJsonTransformer
        self.linkedCharacterPageJsonTransformer = linkedCharacterPageJsonTransformer
    }
    
    private static let fields = (
        entityId : "entityId",
        linkedPageSubType : "linkedPageSubType",
        linkedPageEntityId : "linkedPageEntityId",
        linkedPage : "linkedPage",
        linkedPageDisplayName : "linkedPageDisplayName",
        linkedType : "linkedType",
        linkedValue : "linkedValue",
        linkedCharacterPageEntityId : "linkedCharacterPageEntityId",
        linkedCharacterPage : "linkedCharacterPage",
        linkedCharacterPageDisplayName : "linkedCharacterPageDisplayName",
        reverseLinkedType : "reverseLinkedType",
        reverseLinkedValue : "reverseLinkedValue",
        reverseLinkedPageEntityId : "reverseLinkedPageEntityId",
        reverseLinkedPage : "reverseLinkedPage",
        reverseLinkedPageDisplayName : "reverseLinkedPageDisplayName"
    )
    
    func transform(json: JSON) -> InfoComponentElementEntity {
        let fields = InfoComponentElementJsonTransformer.fields
        let entityId = json[fields.entityId].string ?? ""
        let linkedPageSubType = json[fields.linkedPageSubType].string ?? ""
        let linkedPageEntityId = json[fields.linkedPageEntityId].string ?? ""
        let linkedPage = self.linkedPageJsonTransformer.transform(json: json[fields.linkedPage])
        let linkedPageDisplayName = json[fields.linkedPageDisplayName].string ?? ""
        let linkedType = json[fields.linkedType].string ?? ""
        let linkedValue = json[fields.linkedValue] == JSON.null ? nil :
            linkedValueJsonTransformer.transform(json: json[fields.linkedValue])
        let linkedCharacterPageEntityId = json[fields.linkedCharacterPageEntityId].string ?? ""
        let linkedCharacterPage = linkedCharacterPageJsonTransformer.transform(json: json[fields.linkedCharacterPage])
        let linkedCharacterPageDisplayName = json[fields.linkedCharacterPageDisplayName].string ?? ""
        let reverseLinkedType = json[fields.reverseLinkedType].string ?? ""
        let reverseLinkedValue = json[fields.reverseLinkedValue] == JSON.null ? nil :
            linkedValueJsonTransformer.transform(json: json[fields.reverseLinkedValue])
        let reverseLinkedPageEntityId = json[fields.reverseLinkedPageEntityId].string ?? ""
        let reverseLinkedPage = linkedCharacterPageJsonTransformer.transform(json: json[fields.reverseLinkedPage])
        let reverseLinkedPageDisplayName = json[fields.reverseLinkedPageDisplayName].string ?? ""
        
        return InfoComponentElementEntity(entityId: entityId, linkedPageSubType: linkedPageSubType,
                                          linkedPageEntityId: linkedPageEntityId, linkedPage: linkedPage,
                                          linkedPageDisplayName: linkedPageDisplayName,
                                          linkedType: linkedType, linkedValue: linkedValue,
                                          linkedCharacterPageEntityId: linkedCharacterPageEntityId,
                                          linkedCharacterPage: linkedCharacterPage,
                                          linkedCharacterPageDisplayName: linkedCharacterPageDisplayName,
                                          reverseLinkedType: reverseLinkedType, reverseLinkedValue: reverseLinkedValue,
                                          reverseLinkedPageEntityId: reverseLinkedPageEntityId,
                                          reverseLinkedPage: reverseLinkedPage,
                                          reverseLinkedPageDisplayName: reverseLinkedPageDisplayName)
    }
}

class LinkedCharacterPageJsonTransformer: JsonTransformer {
    
    private static let fields = (
        entityId : "entityId",
        displayName : "displayName"
    )
    
    func transform(json: JSON) -> LinkedCharacterPageEntity {
        let fields = LinkedCharacterPageJsonTransformer.fields
        let entityId = json[fields.entityId].string ?? ""
        let displayName = json[fields.displayName].string ?? ""
        
        return LinkedCharacterPageEntity(entityId: entityId, displayName: displayName)
    }
}

class LinkedValueJsonTransformer: JsonTransformer {
    private static let fields = "metadata"
    let infoMetadataJsonTransformer: InfoMetaDataJsonTransformer
    
    init(infoMetadataJsonTransformer: InfoMetaDataJsonTransformer) {
        self.infoMetadataJsonTransformer = infoMetadataJsonTransformer
    }
    func transform(json: JSON) -> LinkedValueEntity {
        //if json is an array
        if let jsonArray = json.array {
            let metadata = jsonArray.map { infoMetadataJsonTransformer.transform(json: $0) }
            return LinkedValueEntity(metadata: metadata)
        }
        
        //json is a dictionary
        let jsonDict = json[LinkedValueJsonTransformer.fields]
        
        if let metaDataArray = jsonDict.array { // metadata is an array of string
            let metadata = metaDataArray.map({ infoMetadataJsonTransformer.transform(json: $0) })
            return LinkedValueEntity(metadata: metadata)
        }
        
        if jsonDict.dictionary != nil { // metadata is a dictionary
            let metadata = [infoMetadataJsonTransformer.transform(json: jsonDict)]
            return LinkedValueEntity(metadata: metadata)
        }
        
        // metadata is a string
        let metaValue = jsonDict.string ?? ""
        let metaData = [InfoMetaDataEntity(code: metaValue, name: metaValue)]
        return LinkedValueEntity(metadata: metaData)
    }
}
class InfoMetaDataJsonTransformer: JsonTransformer {
    
    private static let fields = (
        code : "code",
        name : "name"
    )
    
    func transform(json: JSON) -> InfoMetaDataEntity {
        let fields = InfoMetaDataJsonTransformer.fields
        let code = json[fields.code].string ?? ""
        let name = json[fields.name].string ?? ""
        return InfoMetaDataEntity(code: code, name: name)
        
    }
}
