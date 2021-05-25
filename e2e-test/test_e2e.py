def test_browser_title_contains_app_name(homepage):
    assert 'Flashcards' in homepage.title

def test_heading_is_flashcards(homepage):
    heading = homepage.find_element_by_id('heading').text
    assert 'Flashcards' == heading

def test_displays_random_card(homepage):
    phrase_displayed = homepage.find_element_by_id('card').text
    print(phrase_displayed)
    assert 0 < len(phrase_displayed)

def _find(self, val):
    return self.driver.find_element_by_id(val)
