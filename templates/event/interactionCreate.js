const { Client } = require("discord.js")
const { existsSync } = require("fs");
const edb = require("../edb");

/**
 * @param {Client} client 
 * @param {import("discord.js").Interaction} interaction
 */
module.exports = async (client, interaction) => {

    if (interaction.isCommand()) {
        if (existsSync(`./commands/${interaction.commandName}.js`)) require(`../commands/${interaction.commandName}.js`).execute(client, interaction)
        else {
            interaction.reply({ content: `Error in the bot code. No file named "${interaction.commandName}.js" in the /commands directory`, ephemeral: true });
            edb.log.error(`[!!] No file named "${interaction.commandName}.js" in the /commands directory`);
        };
    }
}
