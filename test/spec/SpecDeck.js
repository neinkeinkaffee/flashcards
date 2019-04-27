describe('Testing manipulation of the flashcard deck', ()=> {
    it('should add a new flashcard', () => {
        let deck = new Deck()
        let card = {
            chinese: '咖啡',
            english: 'coffee'
        }
        deck.add(card)
        expect(deck.getCards().length).toBe(1)
    })
    it('should delete a flashcard', () => {
        let deck = new Deck()
        let card1 = {
            chinese: '咖啡',
            english: 'coffee'
        }
        let card2 = {
            chinese: '茶',
            english: 'tea'
        }
        id1 = deck.add(card1)
        id2 = deck.add(card2)
        expect(deck.getCards().length).toBe(2)
        deck.delete(id2)
        expect(deck.getCards().length).toBe(1);
        expect(deck.getCards()[0].uuid).toBe(id1)
    })
    it()
})