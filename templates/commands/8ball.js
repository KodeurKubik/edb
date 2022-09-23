const { SlashCommandBuilder, Client, EmbedBuilder } = require("discord.js");

module.exports = {
    slash: new SlashCommandBuilder()
        .setName('8ball')
        .setDescription('Ask a question to the magic 🎱')
        .addStringOption(opt =>
            opt.setName('question')
                .setDescription('The question to ask to the magic ball')
                .setRequired(true)
        )
    ,
    guilds: 'ALL', // Put ALL for a general slash command or put an array of guild id's to create the command in specific guilds
                // guild: "ALL"
                // guild: ['Guild Id 1', 'Guild Id 2', '...']
    /**
     * @param {Client} client 
     * @param {import("discord.js").Interaction} interaction 
     */
    execute: async (client, interaction) => {
        const balls = ['Yes !', 'Very much !', 'Yeah !', 'Uhhh...', 'It\'s possible', 'I don\'t now', 'I\'m not sure about that', 'A little bit', 'No', 'Never', 'Don\'t !!']
        const rep = balls[Math.floor(Math.random() * (balls.length - 1))]

        await interaction.reply({ embeds: [
            new EmbedBuilder()
                .setDescription(`**</8ball:${/* I don't know yet how to get the id for the clickable command so I put 0*/ 0}> command**`)
                .addFields(
                    { name: '❓ Question', value: interaction.options.get('question').value },
                    { name: '🎱 Answer', value: rep },
                )
                .setColor('Gold')
        ] })
    }
}
