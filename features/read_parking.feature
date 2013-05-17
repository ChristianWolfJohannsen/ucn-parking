Feature: Read Parking Info

	Scenario: Read as HTML
		When I visit /
		Then I should see Føtex

	Scenario: Read as JSON
		When I visit /places/index.json
		Then I should see "name"
		And I should see Budolfi Plads

	Scenario: Read as XML
		When I visit /places/index.xml
		Then I should see <name>C W Obel</name>
