function Deck() {
    this.cards = []
}
Deck.prototype.add = function(card) {
    this.cards.push(card)
}
Deck.prototype.getCards = function() {
    return this.cards
}