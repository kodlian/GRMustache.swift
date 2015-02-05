//
//  ConfigurationBaseContextTests.swift
//  GRMustache
//
//  Created by Gwendal Roué on 04/11/2014.
//  Copyright (c) 2014 Gwendal Roué. All rights reserved.
//

import XCTest
import GRMustache

class ConfigurationBaseContextTests: XCTestCase {
    
    override func tearDown() {
        super.tearDown()
        
        Configuration.defaultConfiguration.baseContext = Configuration().baseContext
    }
    
    func testFactoryConfigurationHasStandardLibraryInBaseContextRegardlessOfDefaultConfiguration() {
        Configuration.defaultConfiguration.baseContext = Context()
        
        let repository = TemplateRepository()
        repository.configuration = Configuration()
        
        let template = repository.template(string: "{{uppercase(foo)}}")!
        let rendering = template.render(boxValue(["foo": "success"]))!
        XCTAssertEqual(rendering, "SUCCESS")
    }
    
    func testDefaultConfigurationCustomBaseContext() {
        Configuration.defaultConfiguration.baseContext = Context(boxValue(["foo": "success"]))
        
        let template = Template(string: "{{foo}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testDefaultConfigurationCustomBaseContextHasNoStandardLibrary() {
        Configuration.defaultConfiguration.baseContext = Context(boxValue(["foo": "success"]))
        
        let template = Template(string: "{{uppercase(foo)}}")!
        var error: NSError?
        let rendering = template.render(error: &error)
        XCTAssertNil(rendering)
        XCTAssertEqual(error!.code, GRMustacheErrorCodeRenderingError); // no such filter
    }
    
    func testTemplateBaseContextOverridesDefaultConfigurationBaseContext() {
        Configuration.defaultConfiguration.baseContext = Context(boxValue(["foo": "failure"]))
        
        let template = Template(string: "{{foo}}")!
        template.baseContext = Context(boxValue(["foo": "success"]))
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testDefaultRepositoryConfigurationHasDefaultConfigurationBaseContext() {
        Configuration.defaultConfiguration.baseContext = Context(boxValue(["foo": "success"]))
        
        let repository = TemplateRepository()
        let template = repository.template(string: "{{foo}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testRepositoryConfigurationBaseContextWhenSettingTheWholeConfiguration() {
        var configuration = Configuration()
        configuration.baseContext = Context(boxValue(["foo": "success"]))
        
        let repository = TemplateRepository()
        repository.configuration = configuration
        
        let template = repository.template(string: "{{foo}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testRepositoryConfigurationBaseContextWhenUpdatingRepositoryConfiguration() {
        let repository = TemplateRepository()
        repository.configuration.baseContext = Context(boxValue(["foo": "success"]))
        
        let template = repository.template(string: "{{foo}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testRepositoryConfigurationBaseContextOverridesDefaultConfigurationBaseContextWhenSettingTheWholeConfiguration() {
        Configuration.defaultConfiguration.baseContext = Context(boxValue(["foo": "failure"]))
        
        var configuration = Configuration()
        configuration.baseContext = Context(boxValue(["foo": "success"]))
        
        let repository = TemplateRepository()
        repository.configuration = configuration
        
        let template = repository.template(string: "{{foo}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testRepositoryConfigurationBaseContextOverridesDefaultConfigurationBaseContextWhenUpdatingRepositoryConfiguration() {
        Configuration.defaultConfiguration.baseContext = Context(boxValue(["foo": "failure"]))
        
        let repository = TemplateRepository()
        repository.configuration.baseContext = Context(boxValue(["foo": "success"]))
        
        let template = repository.template(string: "{{foo}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testTemplateBaseContextOverridesRepositoryConfigurationBaseContextWhenSettingTheWholeConfiguration() {
        var configuration = Configuration()
        configuration.baseContext = Context(boxValue(["foo": "failure"]))
        
        let repository = TemplateRepository()
        repository.configuration = configuration
        
        let template = repository.template(string: "{{foo}}")!
        template.baseContext = Context(boxValue(["foo": "success"]))
        
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testTemplateBaseContextOverridesRepositoryConfigurationBaseContextWhenUpdatingRepositoryConfiguration() {
        let repository = TemplateRepository()
        repository.configuration.baseContext = Context(boxValue(["foo": "failure"]))
        
        let template = repository.template(string: "{{foo}}")!
        template.baseContext = Context(boxValue(["foo": "success"]))
        
        let rendering = template.render()!
        XCTAssertEqual(rendering, "success")
    }
    
    func testRepositoryConfigurationCanBeMutatedBeforeAnyTemplateHasBeenCompiled() {
        // TODO: import test from GRMustache
    }
    
    func testDefaultConfigurationCanBeMutatedBeforeAnyTemplateHasBeenCompiled() {
        // TODO: import test from GRMustache
    }
    
    func testRepositoryConfigurationCanNotBeMutatedAfterATemplateHasBeenCompiled() {
        // TODO: import test from GRMustache
    }
}