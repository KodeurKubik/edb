const { IntentsBitField } = require('discord.js');
const { readFileSync } = require('fs');
const infos = JSON.parse(readFileSync('./edb/infos.json', 'utf8'));

module.exports = {
    intents: Object.keys(IntentsBitField.Flags).filter(intent => isNaN(intent)),
    token: infos.token,
    status: infos.status
}