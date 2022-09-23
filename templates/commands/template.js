const { SlashCommandBuilder, Client } = require("discord.js");

module.exports = {
    slash: new SlashCommandBuilder() // Finish your slash command builder!
        .setName('')
        .setDescription('')
    ,
    guilds: 'ALL', // Put ALL for a general slash command or put an array of guild id's to create the command in specific guilds
                // guild: "ALL"
                // guild: ['Guild Id 1', 'Guild Id 2', '...']
    /**
     * @param {Client} client 
     * @param {import("discord.js").Interaction} interaction 
     */
    execute: async (client, interaction) => {
        // Your code here
    }
}
