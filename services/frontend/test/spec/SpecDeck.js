describe('Testing CRUD operations on the flashcard deck', ()=> {
// Used for unit testing
//    var Deck = require('../../src/Deck');

    function MockApi(cards = []) {
        this.cards = cards;
        this.get = function() {
            return new Promise((resolve, reject) => {
                resolve({ flashcards: this.cards });
            })
        };
        this.post = function(card) {
            this.cards.push(card);
        };
    }
    it('should add a new flashcard', () => {
        let deck = new Deck(new MockApi())
        deck.add('咖啡', 'coffee')
        expect(deck.getCards().length).toBe(1)
    })
    it('should delete a flashcard by id', () => {
        let deck = new Deck(new MockApi())
        id1 = deck.add('咖啡', 'coffee')
        id2 = deck.add('茶', 'tea')
        expect(deck.getCards().length).toBe(2)
        deck.delete(id2)
        expect(deck.getCards().length).toBe(1)
        expect(deck.getCards()[0].uuid).toBe(id1)
    })
    it('should select a random flashcard', () => {
        let deck = new Deck(new MockApi())
        id1 = deck.add('咖啡', 'coffee')
        id2 = deck.add('茶', 'tea')
        // Jasmine reports 'SPEC HAS NO EXPECTATIONS' for the expectation inside the resolve function.
        // However, deck.random().then(random => expect(["foo", "bar"]).toContain(random.uuid)) lets the test fail.
        deck.random()
            .then(random => expect([id1, id2]).toContain(random.uuid))
    })
})
