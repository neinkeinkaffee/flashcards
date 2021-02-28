def test_browser_title_contains_app_name(homepage):
    assert 'Flashcards' in homepage.title

def test_page_heading_is_flashcards(homepage):
    heading = homepage.find_element_by_id('heading').text
    assert 'Flashcards' == heading

# def test_page_has_input_for_text(self):
#     input_element = self._find('input-element')
#     self.assertIsNotNone(input_element)
#
# def test_page_has_button_for_submitting_text(self):
#     submit_button = self._find('find-button')
#     self.assertIsNotNone(submit_button)
#
# def test_page_has_ner_table_on_it(self):
#     input_element = self._find('input-element')
#     submit_button = self._find('find-button')
#     input_element.send_keys('France and Germany share a border in Europe')
#     submit_button.click()
#     ner_table = self._find('ner-table')
#     self.assertIsNotNone(ner_table)

def _find(self, val):
    return self.driver.find_element_by_id(val)
