//
//  LocalizerTests.swift
//  GRMustache
//
//  Created by Gwendal Roué on 17/11/2014.
//  Copyright (c) 2014 Gwendal Roué. All rights reserved.
//

import XCTest
import GRMustache

class LocalizerTests: XCTestCase {
    
    lazy var localizableBundle: NSBundle = NSBundle(path: NSBundle(forClass: self.dynamicType).pathForResource("LocalizerTestsBundle", ofType: nil)!)!
    lazy var localizer: Localizer = Localizer(bundle: self.localizableBundle, table: nil)
    
    func testLocalizableBundle() {
        let testable = localizableBundle.localizedStringForKey("testable?", value:"", table:nil)
        XCTAssertEqual(testable, "YES")
    }
    
    func testLocalizer() {
        let template = Template(string: "{{localize(string)}}")!
        let box = boxValue(["localize": boxValue(localizer), "string": boxValue("testable?")])
        let rendering = template.render(box)!
        XCTAssertEqual(rendering, "YES")
    }
    
    func testLocalizerFromTable() {
        let template = Template(string: "{{localize(string)}}")!
        let localizer = Localizer(bundle: localizableBundle, table: "Table")
        let box = boxValue(["localize": boxValue(localizer), "string": boxValue("table_testable?")])
        let rendering = template.render(box)!
        XCTAssertEqual(rendering, "YES")
    }

    func testDefaultLocalizerAsFilter() {
        let template = Template(string: "{{localize(foo)}}")!
        let box = boxValue(["foo": "bar"])
        let rendering = template.render(box)!
        XCTAssertEqual(rendering, "bar")
    }
    
    func testDefaultLocalizerAsRenderable() {
        let template = Template(string: "{{#localize}}...{{/}}")!
        let rendering = template.render()!
        XCTAssertEqual(rendering, "...")
    }
    
    func testDefaultLocalizerAsRenderableWithArgument() {
        let template = Template(string: "{{#localize}}...{{foo}}...{{/}}")!
        let box = boxValue(["foo": "bar"])
        let rendering = template.render(box)!
        XCTAssertEqual(rendering, "...bar...")
    }
    
    func testDefaultLocalizerAsRenderableWithArgumentAndConditions() {
        let template = Template(string: "{{#localize}}.{{foo}}.{{^false}}{{baz}}{{/}}.{{/}}")!
        let box = boxValue(["foo": "bar", "baz": "truc"])
        let rendering = template.render(box)!
        XCTAssertEqual(rendering, ".bar.truc.")
    }
    
    func testLocalizerAsRenderingObjectWithoutArgumentDoesNotNeedPercentEscapedLocalizedString() {
        var template = Template(string: "{{#localize}}%d{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        var rendering = template.render()!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("%d", value: nil, table: nil), "ha ha percent d %d")
        XCTAssertEqual(rendering, "ha ha percent d %d")
        
        template = Template(string: "{{#localize}}%@{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        rendering = template.render()!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("%@", value: nil, table: nil), "ha ha percent @ %@")
        XCTAssertEqual(rendering, "ha ha percent @ %@")
    }
    
    func testLocalizerAsRenderingObjectWithoutArgumentNeedsPercentEscapedLocalizedString() {
        var template = Template(string: "{{#localize}}%d {{foo}}{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        var rendering = template.render(boxValue(["foo": "bar"]))!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("%%d %@", value: nil, table: nil), "ha ha percent d %%d %@")
        XCTAssertEqual(rendering, "ha ha percent d %d bar")

        template = Template(string: "{{#localize}}%@ {{foo}}{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        rendering = template.render(boxValue(["foo": "bar"]))!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("%%@ %@", value: nil, table: nil), "ha ha percent @ %%@ %@")
        XCTAssertEqual(rendering, "ha ha percent @ %@ bar")
    }
    
    func testLocalizerAsFilter() {
        let template = Template(string: "{{localize(foo)}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        let rendering = template.render(boxValue(["foo": "bar"]))!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("bar", value: nil, table: nil), "translated_bar")
        XCTAssertEqual(rendering, "translated_bar")
    }
    
    func testLocalizerAsRenderable() {
        let template = Template(string: "{{#localize}}bar{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        let rendering = template.render()!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("bar", value: nil, table: nil), "translated_bar")
        XCTAssertEqual(rendering, "translated_bar")
    }
    
    func testLocalizerAsRenderableWithArgument() {
        let template = Template(string: "{{#localize}}..{{foo}}..{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        let rendering = template.render(boxValue(["foo": "bar"]))!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey("..%@..", value: nil, table: nil), "!!%@!!")
        XCTAssertEqual(rendering, "!!bar!!")
    }
    
    func testLocalizerAsRenderableWithArgumentAndConditions() {
        let template = Template(string: "{{#localize}}.{{foo}}.{{^false}}{{baz}}{{/}}.{{/}}")!
        template.baseContext = template.baseContext.extendedContext(boxValue(["localize": boxValue(localizer)]))
        let rendering = template.render(boxValue(["foo": "bar", "baz": "truc"]))!
        XCTAssertEqual(self.localizer.bundle.localizedStringForKey(".%@.%@.", value: nil, table: nil), "!%@!%@!")
        XCTAssertEqual(rendering, "!bar!truc!")
    }
    
    func testLocalizerRendersHTMLEscapedValuesOfHTMLTemplates() {
        var template = Template(string: "{{#localize}}..{{foo}}..{{/}}")!
        var rendering = template.render(boxValue(["foo": "&"]))!
        XCTAssertEqual(rendering, "..&amp;..")

        template = Template(string: "{{#localize}}..{{{foo}}}..{{/}}")!
        rendering = template.render(boxValue(["foo": "&"]))!
        XCTAssertEqual(rendering, "..&..")
    }
    
    func testLocalizerRendersUnescapedValuesOfTextTemplates() {
        var template = Template(string: "{{% CONTENT_TYPE:TEXT }}{{#localize}}..{{foo}}..{{/}}")!
        var rendering = template.render(boxValue(["foo": "&"]))!
        XCTAssertEqual(rendering, "..&..")
        
        template = Template(string: "{{% CONTENT_TYPE:TEXT }}{{#localize}}..{{{foo}}}..{{/}}")!
        rendering = template.render(boxValue(["foo": "&"]))!
        XCTAssertEqual(rendering, "..&..")
    }
}
