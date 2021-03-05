function Deck(api) {
    this.cards = [];
    this.api = api;
    this.api.get()
        .then(data => {
            this.cards = data['flashcards'];
        });
}
Deck.prototype.add = function(chinese, english) {
    card = {
        'chinese' : chinese,
        'english': english,
    }
    this.api.post(card);
    card['uuid'] = Deck.prototype.generateUUID()
    this.cards.push(card);
    return card['uuid']
}
Deck.prototype.delete = function(uuid) {
    this.cards = this.cards.filter(card => {
        return card.uuid !== uuid
    })
}
Deck.prototype.getCards = function() {
    return this.cards
}
Deck.prototype.generateUUID = function() {
    let now = new Date().getTime();
    let uuid = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
        let rand = (now + Math.random() * 16) % 16 | 0;
        now = Math.floor(now / 16);
        return (c == "x" ? rand : (rand & 0x3 | 0x8)).toString(16);
    });
    return uuid;
}
Deck.prototype.random = function() {
    return this.api.get().then(data => {
            let flashcards = data['flashcards'];
            return flashcards;
        })
        .then(flashcards => {
            let rand = Math.floor(Math.random() * flashcards.length);
            return flashcards[rand];
        });
}
// Used for unit testing
//module.exports = Deck;
