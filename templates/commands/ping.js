const { SlashCommandBuilder, Client } = require("discord.js");

module.exports = {
    slash: new SlashCommandBuilder()
        .setName('ping')
        .setDescription('Ping the bot to know if it works!')
    ,
    guilds: "ALL", // Put ALL for a general slash command or put an array of guild id's to create the command in specific guilds
                // guild: "ALL"
                // guild: ['Guild Id 1', 'Guild Id 2', '...']
    /**
     * @param {Client} client 
     * @param {import("discord.js").Interaction} interaction 
     */
    execute: async (client, interaction) => {
        interaction.reply(`Pong!\nLatency: ${client.ws.ping}\nUptime: <t${client.uptime}:> (<t${client.uptime}:R>)`)
    }
}
