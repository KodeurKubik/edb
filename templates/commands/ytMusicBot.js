const { SlashCommandBuilder, Client, Intents } = require('discord.js');
const { joinVoiceChannel, createAudioPlayer, createAudioResource, AudioPlayerStatus } = require('@discordjs/voice');
const ytdl = require('ytdl-core');
const YTSearch = require('yt-search');

module.exports = {
    data: new SlashCommandBuilder()
        .setName('play')
        .setDescription('Plays a YouTube video in your voice channel')
        .addStringOption(option =>
            option.setName('query')
                .setDescription('The search query for YouTube')
                .setRequired(true)),
    async execute(client, interaction) {
        const query = interaction.options.getString('query');
        const voiceChannel = interaction.member.voice.channel;

        if (!voiceChannel) {
            return interaction.reply('You need to be in a voice channel to use this command.');
        }

        // Search YouTube and get the first result's URL
        const searchResults = await YTSearch(query);
        const videoUrl = searchResults.videos.length > 0 ? searchResults.videos[0].url : null;

        if (!videoUrl) {
            return interaction.reply('No results found on YouTube.');
        }

        // Join the voice channel
        const connection = joinVoiceChannel({
            channelId: voiceChannel.id,
            guildId: interaction.guildId,
            adapterCreator: interaction.guild.voiceAdapterCreator,
        });

        // Create a player and resource
        const player = createAudioPlayer();
        const resource = createAudioResource(ytdl(videoUrl, { filter: 'audioonly' }));

        player.play(resource);
        connection.subscribe(player);

        player.on(AudioPlayerStatus.Playing, () => {
            interaction.reply(`Now playing: ${searchResults.videos[0].title}`);
        });

        player.on(AudioPlayerStatus.Idle, () => {
            connection.destroy();
        });

        player.on('error', error => {
            console.error(`Error: ${error.message}`);
        });
    }
};
