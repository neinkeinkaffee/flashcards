function Deck() {
    this.cards = []
}
Deck.prototype.add = function(card) {
    card.uuid = this.generateUUID()
    this.cards.push(card)
    return card.uuid
}
Deck.prototype.delete = function(uuid) {
    this.cards = this.cards.filter(card => {
        console.log(this.cards)
        console.log(card.uuid !== uuid)
        card.uuid !== uuid
    })
}
Deck.prototype.getCards = function() {
    return this.cards
}
Deck.prototype.generateUUID = function() {
    var now = new Date().getTime();
    var uuid = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
        var rand = (now + Math.random() * 16) % 16 | 0;
        now = Math.floor(now / 16);
        return (c == "x" ? rand : (rand & 0x3 | 0x8)).toString(16);
    });
    return uuid;
}