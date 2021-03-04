describe('Testing CRUD operations on the flashcard deck', ()=> {
    it('should add a new flashcard', () => {
        let deck = new Deck()
        deck.add('咖啡', 'coffee')
        expect(deck.getCards().length).toBe(1)
    })
    it('should delete a flashcard by id', () => {
        let deck = new Deck()
        id1 = deck.add('咖啡', 'coffee')
        id2 = deck.add('茶', 'tea')
        expect(deck.getCards().length).toBe(2)
        deck.delete(id2)
        expect(deck.getCards().length).toBe(1)
        expect(deck.getCards()[0].uuid).toBe(id1)
    })
    it('should select a random flashcard', () => {
        let deck = new Deck()
        id1 = deck.add('咖啡', 'coffee')
        id2 = deck.add('茶', 'tea')
        let randomCard = deck.random()
        expect([id1, id2]).toContain(randomCard.uuid)
    })
})
