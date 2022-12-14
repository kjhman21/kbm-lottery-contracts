const Caver = require('caver-js')
const abi = require('./abi.json')
// const url = 'https://api.baobab.klaytn.net:8651/'
const url = 'https://public-node-api.klaytnapi.com/v1/cypress'
const caver = new Caver(url)
const filepath = `../../Documents/Authentication/kaikas-0x0137128e1b02b8e841bc14659cdcbb714840dfd3.json`
const kip17Address = "0xdb3ffc3bc2726872ae58c92d53a71cf350579ef8"

async function loadPassword() {
    var read = require('read')

    return new Promise((resolve, reject)=> {
        read({ prompt: 'Password: ', silent: true }, function(er, password) {
            if(er) {
                reject(er)
                return
            }
            resolve(password)
        })

    })

}

module.exports = {
    abi,
    caver,
    filepath,
    kip17Address,
    loadPassword
}