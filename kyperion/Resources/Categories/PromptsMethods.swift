//
//  PromptsMethods.swift
//  kyperion
//
//  Copyright © 2015 kyperion. All rights reserved.
//

import UIKit

extension KYPromptsView {
    
    private class func createBasePrompt(message: String, bounds: CGRect) -> KYPromptsView {
        
        let prompt = KYPromptsView(frame: bounds)
        
        prompt.setBlurringLevel(2.0)
        prompt.setColorWithTransparency(UIColor.clearColor())
        prompt.setPromptHeader(PROMPT_TITLE)
        prompt.setPromptContentText(message)
        prompt.setPromptTopBarVisibility(true)
        prompt.setPromptBottomBarVisibility(false)
        prompt.setPromptTopLineVisibility(false)
        prompt.setPromptBottomLineVisibility(true)
        prompt.setPromptHeaderBarColor(UIColor.mainAppColor())
        prompt.setPromptHeaderTxtColor(UIColor.whiteColor())
        prompt.setPromptBottomLineColor(UIColor.mainAppColor())
        
        return prompt
    }
    
    
    class func createPromptWithMessageAndBounds(message: String, bounds: CGRect) -> KYPromptsView {
        
        let prompt = self.createBasePrompt(message, bounds: bounds)
        
        // Set proper message
        prompt.setPromptContentTxtColor(UIColor.mainAppColor())
        prompt.setMainButtonText(PROMPT_OK_MSG)
        
        return prompt
    }
    
    class func createQuestionPrompt(typeQuestion: TYPE_QUESTION, questionText: String, bounds: CGRect) -> KYPromptsView {
        
        let prompt = self.createBasePrompt(questionText, bounds: bounds)
        
        // Set proper message
        prompt.setPromptButtonDividerColor(UIColor.mainAppColor())
        prompt.enableDoubleButtonsOnPrompt()
        prompt.setMainButtonText(mainBotonText)
        prompt.setSecondButtonText(secondBotonText)
        prompt.isQuestion = true
        prompt.typeQuestion = typeQuestion
        
        return prompt
    }

}