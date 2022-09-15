function color(msg, color) {
    console.log(`\x1b[${color}m${msg}\x1b[0m`)
}

module.exports = {
    error: (error) => color(error, "91"),
    warn: (warn) => color(warn, '93'),
    log: (log) => console.log(log)
}