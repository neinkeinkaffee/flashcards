describe('Testing manipulation of the flashcard deck', ()=>{
    it('should add a new flashcard', ()=>{
        let deck = new Deck();
        let card = {
            chinese: "中文",
            english: "Chinese"
        }
        deck.add(card)
        expect(deck.getCards().length).toBe(1);
    })
})