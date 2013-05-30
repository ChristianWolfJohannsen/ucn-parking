Feature: Read Parking Info
	In order to see available parking spaces in Aalborg
  As a viewer
  I want to see the home page

	Scenario: Read as HTML
		When I visit '/'
		Then I should see 'Føtex'

	Scenario: Read as JSON
		When I visit '/places.json'
		Then I should see '[{"name":"Budolfi '

	Scenario: Read as XML
		When I visit '/places.xml'
		Then I should see 'C W Obel'
