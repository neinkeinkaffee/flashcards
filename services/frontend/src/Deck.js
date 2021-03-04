function Deck() {
    this.cards = []
    fetch('$BASE_URL' + '/flashcards')
        .then(response => response.json())
        .then(data => {
            console.log(data);
            this.cards = data['flashcards'];
            console.log(this.cards);
        });
}
Deck.prototype.add = function(chinese, english) {
    card = {
        'chinese' : chinese,
        'english': english,
    }
    console.log(JSON.stringify(card))
    fetch('$BASE_URL' + '/flashcards', {
        method: 'POST',
        body: JSON.stringify(card), // string or object
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
        }
    });
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
    let rand = Math.floor((Math.random() * this.cards.length))
    console.log(this.cards[rand]);
    return this.cards[rand];
}
