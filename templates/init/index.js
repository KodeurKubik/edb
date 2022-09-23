//=============== REQUIRES =======================\\
const { intents, token, status } = require('./config.js');
const { Client } = require('discord.js');
const { readdirSync } = require('fs');
const client = new Client({ intents });
const edb = require('./edb/index.js');
const commands = new Map();
//================================================\\

client.once('ready', async () => {
    let cmds = {};
    await readdirSync('./commands').forEach(async path => {
        if (!path.endsWith('.js')) return edb.log.warn(`[!] File "${path}" in /commands don't end with .js | Skipping...`)
        let f = require(`./commands/${path}`);
        if (!f?.slash || typeof f?.slash != 'object' || !f.guilds || (typeof f?.guilds != 'string' && !Array.isArray(f?.guilds)) || !f?.execute || typeof f?.execute != 'function') return edb.log.warn(`[!] Command "${path}" don't respect patern of module.exports! See here: https://github.com/TotoroGaming/edb/wiki/Exporting-things#export-a-command`)
        if (typeof f.guilds == 'string') { if (cmds['ALL']) { cmds['ALL'].push(f.slash) } else cmds['ALL'] = [f.slash] }
        else { f.guilds.forEach(g => { if (cmds[g]) { cmds[g].push(f.slash) } else cmds[g] = [f.slash] }) };
    })
    await Object.keys(cmds).forEach(async guild => {
        let cmd = cmds[guild];
        if (guild == 'ALL') { client.application.commands.set(cmd); }
        else { if (!client.guilds.cache.get(guild)) return edb.log.warn(`[!] Commands for guild "${g}" not loaded | Guild not found`); client.guilds.cache.get(guild).commands.set(cmd); }
        await cmd.forEach(c => {
            edb.log.log(`[-] Deployed "${c.name}" command in ${(guild == 'ALL') ? 'all guilds' : `the "${client.guilds.cache.get(guild).name}" guild` }`);
            commands.set(c.name, { name: c.name, description: c.description, options: c.options });
        })
    })

    await readdirSync('./events').forEach(async path => {
        if (!path.endsWith('.js')) return edb.log.warn(`[!] File "${path}" in /events don't end with .js | Skipping...`)
        let f = require(`./events/${path}`);
        if (!f || typeof f != 'function') return edb.log.warn(`[!] Event "${path}" don't respect patern of module.exports! See here: https://github.com/TotoroGaming/edb/wiki/Exporting-things#export-an-event`)
        if (path == 'ready.js') f(client)
        else client.on(path.replace('.js', ''), (...args) => f(client, ...args));
        await edb.log.log(`[-] Loaded "${path}" event`);
    })

    if (status != {}) client.user.setActivity(status);
})
client.login(token);
